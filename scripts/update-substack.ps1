param([string]$FeedPath, [string]$PagePath = "$PSScriptRoot/../writings/index.html")
$ErrorActionPreference = 'Stop'
$xml = if ($FeedPath) { [IO.File]::ReadAllText($FeedPath) } else {
    try {
        (Invoke-WebRequest -Uri 'https://blowthepopsiclestand.substack.com/feed' -TimeoutSec 60 -MaximumRetryCount 2 -RetryIntervalSec 5).Content
    } catch {
        # Substack sometimes challenges requests from GitHub-hosted runners.
        # Skip only known access/rate-limit responses; parsing and other errors
        # must still fail so actual updater defects remain visible.
        $status = if ($_.Exception.Response) { [int]$_.Exception.Response.StatusCode } else { 0 }
        $page = [IO.File]::ReadAllText($PagePath)
        $hasSavedPosts = $page -match '(?s)<!-- BEGIN SUBSTACK PUBLICATIONS -->\s*<article>.*?<!-- END SUBSTACK PUBLICATIONS -->'
        if ($status -notin @(403, 429) -or !$hasSavedPosts) { throw }
        $message = "Substack refresh skipped (HTTP $status). Saved posts remain visible. New posts may be delayed until Substack accepts requests; the next scheduled run will retry."
        if ($env:GITHUB_ACTIONS -eq 'true') {
            Write-Host "::warning title=Substack feed unavailable::$message"
            if ($env:GITHUB_STEP_SUMMARY) {
                Add-Content -LiteralPath $env:GITHUB_STEP_SUMMARY -Value "### Substack refresh skipped`n$message`n"
            }
        } else {
            Write-Warning $message
        }
        return
    }
}
$doc = [xml]::new()
$doc.XmlResolver = $null
$doc.LoadXml($xml)
function Encode([string]$value) { [Net.WebUtility]::HtmlEncode(($value -replace '\s+', ' ').Trim()) }
$posts = @($doc.SelectNodes('/rss/channel/item') | ForEach-Object {
    $link = [uri]$_.SelectSingleNode('link').InnerText
    if ($link.Scheme -ne 'https' -or $link.Host -ne 'blowthepopsiclestand.substack.com') { throw 'Unexpected Substack post URL.' }
    $title = $_.SelectSingleNode('title').InnerText
    if ([string]::IsNullOrWhiteSpace($title)) { throw 'Missing Substack title.' }
    [pscustomobject]@{
        Title = Encode $title
        Link = Encode $link.AbsoluteUri
        Date = [DateTimeOffset]::Parse($_.SelectSingleNode('pubDate').InnerText, [Globalization.CultureInfo]::InvariantCulture)
    }
} | Sort-Object Date -Descending)
if (!$posts.Count) { throw 'No Substack posts returned; preserving saved posts.' }
$articles = foreach ($post in $posts) {
    $date = $post.Date.ToString('MMMM d, yyyy', [Globalization.CultureInfo]::InvariantCulture)
    $iso = $post.Date.ToString('yyyy-MM-dd')
    @"
            <article>
              <h3><a href="$($post.Link)">$($post.Title)</a></h3>
              <span class="date-text"><time datetime="$iso">$date</time></span>
              <p><a href="$($post.Link)">Read on Substack</a></p>
            </article>
"@
}
$page = [IO.File]::ReadAllText($PagePath)
$pattern = '(?s)<!-- BEGIN SUBSTACK PUBLICATIONS -->.*?<!-- END SUBSTACK PUBLICATIONS -->'
if ([regex]::Matches($page, $pattern).Count -ne 1) { throw 'Expected exactly one Substack publication block.' }
$newline = if ($page.Contains("`r`n")) { "`r`n" } else { "`n" }
$body = (($articles -join "`n") -replace '\r?\n', $newline)
$replacement = '<!-- BEGIN SUBSTACK PUBLICATIONS -->' + $newline + $body + $newline + '          <!-- END SUBSTACK PUBLICATIONS -->'
$updated = [regex]::Replace($page, $pattern, [Text.RegularExpressions.MatchEvaluator]{ param($match) $replacement })
if ($updated -cne $page) { [IO.File]::WriteAllText($PagePath, $updated, [Text.UTF8Encoding]::new($false)) }
Write-Host "Verified $($posts.Count) Substack posts."
