param([string]$FeedPath, [string]$PagePath = "$PSScriptRoot/../writings/index.html")
$ErrorActionPreference = 'Stop'

# Query broadly, then match the full author name to exclude other De Mendozas.
$url = 'https://export.arxiv.org/api/query?search_query=au:%22De_Mendoza%22+AND+cat:quant-ph&start=0&max_results=100&sortBy=submittedDate&sortOrder=descending'
if ($FeedPath) {
    $xml = [IO.File]::ReadAllText($FeedPath)
} else {
    $xml = (Invoke-WebRequest -Uri $url -TimeoutSec 60 -MaximumRetryCount 2 -RetryIntervalSec 5).Content
}
$doc = [xml]::new()
$doc.XmlResolver = $null
$doc.LoadXml($xml)
$ns = [Xml.XmlNamespaceManager]::new($doc.NameTable)
$ns.AddNamespace('a', 'http://www.w3.org/2005/Atom')
$ns.AddNamespace('o', 'http://a9.com/-/spec/opensearch/1.1/')
$total = $doc.SelectSingleNode('/a:feed/o:totalResults', $ns)
if (!$total -or [int]$total.InnerText -gt 100) { throw 'Invalid or truncated arXiv response; keeping existing publications.' }
function Encode([string]$value) { [Net.WebUtility]::HtmlEncode(($value -replace '\s+', ' ').Trim()) }
$articles = @()
foreach ($entry in $doc.SelectNodes('/a:feed/a:entry', $ns)) {
    $authors = @($entry.SelectNodes('a:author/a:name', $ns) | ForEach-Object { $_.InnerText.Trim() })
    if ($authors -notcontains 'Juan Gonzalez De Mendoza') { continue }
    $id = $entry.SelectSingleNode('a:id', $ns).InnerText
    if ($id -notmatch '^https?://arxiv.org/abs/(\d{4}\.\d{4,5})(v\d+)?$') { throw "Unexpected arXiv ID: $id" }
    $paperId = $Matches[1]
    $title = Encode $entry.SelectSingleNode('a:title', $ns).InnerText
    $date = [DateTimeOffset]::Parse($entry.SelectSingleNode('a:published', $ns).InnerText)
    $dateText = $date.ToString('MMMM d, yyyy', [Globalization.CultureInfo]::InvariantCulture)
    $isoDate = $date.ToString('yyyy-MM-dd')
    $names = Encode ($authors -join ', ')
    $articles += @"
            <article>
              <h3><a href="https://arxiv.org/abs/$paperId">$title</a></h3>
              <p class="publication-authors">$names</p>
              <span class="date-text"><time datetime="$isoDate">$dateText</time></span>
              <p><a href="https://arxiv.org/abs/$paperId">arXiv:$paperId</a> &middot; <a href="https://arxiv.org/pdf/$paperId">PDF</a></p>
            </article>
"@
}
if (!$articles.Count) { throw 'No matching publications; keeping existing publications.' }
$page = [IO.File]::ReadAllText($PagePath)
$pattern = '(?s)(<!-- BEGIN ARXIV PUBLICATIONS -->).*?(<!-- END ARXIV PUBLICATIONS -->)'
if ([regex]::Matches($page, $pattern).Count -ne 1) { throw 'Expected exactly one publication block.' }
$oldBlock = [regex]::Match($page, $pattern).Value
if ([regex]::Matches($oldBlock, '<article>').Count -gt $articles.Count) { throw 'Publication count decreased; review the feed before removing papers.' }
$newline = if ($page.Contains("`r`n")) { "`r`n" } else { "`n" }
$body = (($articles -join "`n") -replace '\r?\n', $newline)
$replacement = '<!-- BEGIN ARXIV PUBLICATIONS -->' + $newline + $body + $newline + '          <!-- END ARXIV PUBLICATIONS -->'
$updated = [regex]::Replace($page, $pattern, [Text.RegularExpressions.MatchEvaluator]{ param($match) $replacement })
if ($updated -cne $page) { [IO.File]::WriteAllText($PagePath, $updated, [Text.UTF8Encoding]::new($false)) }
Write-Host "Verified $($articles.Count) publications."
