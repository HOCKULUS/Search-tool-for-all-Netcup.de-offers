$content = @()
$i = 0
$errorcount = 0
while($i -lt 9999 -and $errorcount -lt 100){
    $i ++
    try{
        $test = Invoke-WebRequest -uri "https://www.netcup.de/bestellen/produkt.php?produkt=$i"
        $content += ("<b><a href=" + $test.BaseResponse.ResponseUri.AbsoluteUri + ">" + $test.AllElements[3].innerText.ToString() + "</a></b>" + "<br><br>" + $test.AllElements[388].innerText + "<br>" + $test.AllElements[512].innerText + '<details><summary style="cursor:pointer">Mehr</summary><p>' + $test.ParsedHtml.body.innerText + '</p></details>' + "<br><br>").toString()
        Write-Host $i -ForegroundColor green
        $errorcount = 0
    }
    catch{
        Write-Host "404" -ForegroundColor Red
        $errorcount ++
    }
}
set-content -Value  $content -Path "$env:HOMEPATH\desktop\export.html"
