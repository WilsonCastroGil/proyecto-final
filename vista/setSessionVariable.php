<?php
session_start();
if (isset($_GET[choiceSelected])) 
{
$_SESSION['$selected']=$_GET[choiceSelected];   
}
?>