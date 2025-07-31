param (
    [string]$VariableName = "IMGFolder1"
)

Add-Type -AssemblyName System.Windows.Forms

try {
    $folderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog
    $folderBrowser.Description = "Selecciona una carpeta para $VariableName"

    if ($folderBrowser.ShowDialog() -eq "OK") {
        $selectedPath = $folderBrowser.SelectedPath
        $base = Split-Path $MyInvocation.MyCommand.Path
        $skinRoot = Resolve-Path (Join-Path $base "..")
        $incPath = Join-Path $skinRoot.Path "@Resources\Variables.inc"

        if (-not (Test-Path $incPath)) {
            throw "No se encontró el archivo Variables.inc en: $incPath"
        }

        $contenido = Get-Content $incPath -Encoding Default
        $modificado = $false
        $resultado = @()

        foreach ($linea in $contenido) {
            if ($linea -match "^\s*$VariableName\s*=") {
                $resultado += "$VariableName=$selectedPath"
                $modificado = $true
            } else {
                $resultado += $linea
            }
        }

        if (-not $modificado) {
            $resultado += "$VariableName=$selectedPath"
        }

        $resultado | Out-File -Encoding Default $incPath

        Start-Process "C:\Program Files\Rainmeter\Rainmeter.exe" -ArgumentList "!RefreshApp"
    }

} catch {
    [System.Windows.Forms.MessageBox]::Show("Error: $($_.Exception.Message)", "Rainmeter Error", "OK", "Error")
}
