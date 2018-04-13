function Get-AssemblyDebuggableAttribute($path) {
     $assembly = [Reflection.Assembly]::LoadFile($path)
     $attribute = $assembly.GetCustomAttributes([Diagnostics.DebuggableAttribute], $false)

     if (!$attribute) { 
         return $null
     }
     else {

         $obj = New-Object PSObject
         $obj | Add-Member Assembly (Get-Item $path).Basename
         $obj | Add-Member IsJITTrackingEnabled $attribute.IsJITTrackingEnabled
         $obj | Add-Member IsJITOptimizerDisabled $attribute.IsJITOptimizerDisabled
         $obj | Add-Member DebuggingFlags $attribute.DebuggingFlags

         return $obj
     }
 }

$array = @();

Get-ChildItem "${pwd}" -Filter *.exe | Foreach-Object {

    $result = Get-AssemblyDebuggableAttribute($_.FullName)

    if($result -ne $null) {
        $array += $result;
    }
}
Write-Output $array | Format-Table -AutoSize
