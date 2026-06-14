param (
    [string]$VariableName = "IMGNotes"
)

Add-Type -AssemblyName System.Windows.Forms

try {
    $dialog = New-Object System.Windows.Forms.OpenFileDialog
    $dialog.Title = "Selecciona una imagen"
    $dialog.Filter = "Archivos de imagen|*.png;*.jpg;*.jpeg;*.bmp;*.gif"

    $base = Split-Path $MyInvocation.MyCommand.Path
    $skinRoot = Resolve-Path (Join-Path $base "..")
    $dialog.InitialDirectory = Join-Path $skinRoot.Path "@Resources\img"

    if ($dialog.ShowDialog() -eq "OK") {
        $selectedPath = $dialog.FileName
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
