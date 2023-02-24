$i = 0
$errorcount = 0
$content = "
<style>
.domain{
background-color:rgba(0,255,255,0.4);
border:1px solid black;
border-radius:15px;
padding:5px;
}
.hosting{
background-color:rgba(255,255,0,0.4);
border:1px solid black;
border-radius:15px;
padding:5px;
}
.gutschein{
background-color:rgba(0,0,255,0.4);
border:1px solid black;
border-radius:15px;
padding:5px;
}
.server{
background-color:rgba(255,0,0,0.4);
border:1px solid black;
border-radius:15px;
padding:5px;
}
.other{
background-color:rgba(255,0,255,0.4);
border:1px solid black;
border-radius:15px;
padding:5px;
}
</style>
<script>
function hide(sample){var divsToHide = document.getElementsByName(''+sample+'');for(var i = 0; i < divsToHide.length; i++){if(divsToHide[i].style.display == 'none'){divsToHide[i].style.display = '';}else{divsToHide[i].style.display = 'none';}}}

</script>
<div style='padding:20px;background-color:#fff;display: block;position:sticky;top:0px;right:0px'> <div class='domain' style='cursor:pointer;display: inline;' onclick=hide('domain')>domain</div> <div class='hosting' style='cursor:pointer;display: inline;' onclick=hide('hosting')>hosting</div> <div class='server' style='cursor:pointer;display: inline;' onclick=hide('server')>server</div> <div class='gutschein' style='cursor:pointer;display: inline;' onclick=hide('gutschein')>gutschein</div> <div class='other' style='cursor:pointer;display: inline;' onclick=hide('other')>andere</div> </div>"
while($i -lt 9999 -and $errorcount -lt 60){
    $i ++
    try{
        $test = Invoke-WebRequest -uri "https://www.netcup.de/bestellen/produkt.php?produkt=$i"
        if(($test.AllElements[3].innerText.ToString() -match "Domain") -and !($test.AllElements[3].innerText.ToString() -match "Gutschein")){
            $content += ("<div class='domain' name='domain'><b><a href=" + $test.BaseResponse.ResponseUri.AbsoluteUri + ">" + $test.AllElements[3].innerText.ToString() + "</a></b>" + "<br><br>" + $test.AllElements[388].innerText + "<br>" + $test.AllElements[512].innerText + '<details><summary style="cursor:pointer">Mehr</summary><p>' + $test.ParsedHtml.body.innerText + '</p></details>' + "<br><br></div>").toString()
        }
        else{
            if(($test.AllElements[3].innerText.ToString() -match "hosting" -or $test.AllElements[3].innerText.ToString() -match "Webhosting") -and !($test.AllElements[3].innerText.ToString() -match "Gutschein")){
                $content += ("<div class='hosting' name='hosting'><b><a href=" + $test.BaseResponse.ResponseUri.AbsoluteUri + ">" + $test.AllElements[3].innerText.ToString() + "</a></b>" + "<br><br>" + $test.AllElements[388].innerText + "<br>" + $test.AllElements[512].innerText + '<details><summary style="cursor:pointer">Mehr</summary><p>' + $test.ParsedHtml.body.innerText + '</p></details>' + "<br><br></div>").toString()
            }
            else{
                if(($test.AllElements[3].innerText.ToString() -match " S " -or  $test.AllElements[3].innerText.ToString() -match "VPS" -or $test.AllElements[3].innerText.ToString() -match "PS" -or $test.AllElements[3].innerText.ToString() -match "RS") -and !($test.AllElements[3].innerText.ToString() -match "Gutschein")){
                    $content += ("<div class='server' name='server'><b><a href=" + $test.BaseResponse.ResponseUri.AbsoluteUri + ">" + $test.AllElements[3].innerText.ToString() + "</a></b>" + "<br><br>" + $test.AllElements[388].innerText + "<br>" + $test.AllElements[512].innerText + '<details><summary style="cursor:pointer">Mehr</summary><p>' + $test.ParsedHtml.body.innerText + '</p></details>' + "<br><br></div>").toString()
                }
                else{
                    if($test.AllElements[3].innerText.ToString() -match "Gutschein"){
                            $content += ("<div class='gutschein' name='gutschein'><b><a href=" + $test.BaseResponse.ResponseUri.AbsoluteUri + ">" + $test.AllElements[3].innerText.ToString() + "</a></b>" + "<br><br>" + $test.AllElements[388].innerText + "<br>" + $test.AllElements[512].innerText + '<details><summary style="cursor:pointer">Mehr</summary><p>' + $test.ParsedHtml.body.innerText + '</p></details>' + "<br><br></div>").toString()
                    }
                    else{
                            $content += ("<div class='other' name='other'><b><a href=" + $test.BaseResponse.ResponseUri.AbsoluteUri + ">" + $test.AllElements[3].innerText.ToString() + "</a></b>" + "<br><br>" + $test.AllElements[388].innerText + "<br>" + $test.AllElements[512].innerText + '<details><summary style="cursor:pointer">Mehr</summary><p>' + $test.ParsedHtml.body.innerText + '</p></details>' + "<br><br></div>").toString()
                    }
                }
            }
        }
        Write-Host $i -ForegroundColor green
        $errorcount = 0
    }
    catch{
        Write-Host "404" -ForegroundColor Red
        $errorcount ++
    }
}
set-content -Value  $content -Path "$env:HOMEPATH\desktop\export.html"
