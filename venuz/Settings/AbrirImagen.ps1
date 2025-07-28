Add-Type -AssemblyName System.Windows.Forms
try {
    $dialog = New-Object System.Windows.Forms.OpenFileDialog
    $dialog.Title = "Selecciona una imagen"
    $dialog.Filter = "Archivos de imagen|*.png"
    $base = Split-Path $MyInvocation.MyCommand.Path
    $skinRoot = Resolve-Path (Join-Path $base "..")
    $dialog.InitialDirectory = Join-Path $skinRoot.Path "@Resources\img"

    if ($dialog.ShowDialog() -eq "OK") {
        $fileName = [System.IO.Path]::GetFileName($dialog.FileName)  # Solo el nombre del archivo
        $incPath = Join-Path $skinRoot.Path "@Resources\Variables.inc"

        if (-not (Test-Path $incPath)) {
            throw "No se encontró el archivo Variables.inc en: $incPath"
        }

        $contenido = Get-Content $incPath
        $modificado = $false
        $resultado = @()

        foreach ($linea in $contenido) {
            if ($linea -match "^\s*IMGNotes\s*=") {
                $resultado += "IMGNotes=$fileName"
                $modificado = $true
            } else {
                $resultado += $linea
            }
        }

        if (-not $modificado) {
            $resultado += "IMGNotes=$fileName"
        }

        $resultado | Out-File -Encoding ASCII $incPath

        # Refrescar Rainmeter
        Start-Process "C:\Program Files\Rainmeter\Rainmeter.exe" -ArgumentList "!RefreshApp"
    }
} catch {
    [System.Windows.Forms.MessageBox]::Show("Error: $($_.Exception.Message)", "Rainmeter Error", "OK", "Error")
}
