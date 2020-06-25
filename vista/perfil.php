
<script language="JavaScript" type="text/javascript">
function takeValue()
{
var sel = document.getElementById("selectedReport");
var selectedReport = sel.options[sel.selectedIndex].text;
var xmlhttp;

if (window.XMLHttpRequest)
{// code for IE7+, Firefox, Chrome, Opera, Safari
xmlhttp=new XMLHttpRequest();
}
else
{// code for IE6, IE5
xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
}
xmlhttp.onreadystatechange=function()
{
}

urlString="setSessionVariable.php?choiceSelected=" + selectedReport;
xmlhttp.open("GET",urlString,true);
xmlhttp.send();
}
</script>



<section class="container-fluid">



<div class="row-12">




    <div class="row">




        <div class="col-sm-4"></div>
        <div class="col mt-5">
            <form class="mt-5 form-container" method="POST" id="formLogin">
              
                    <div class="form-group">

                    <select id="selectedReport" onchange="takeValue()">
<option value="Yes" Selected>Yes</option>
<option value="No" >No</option>
</select>

                    </div>

            </form>
        </div>
        <div class="col-sm-4"></div>
    </div>
</section>