function UpdateAccentColors()

    local accent = SKIN:GetMeasure('mAccentColor'):GetStringValue()
    local current = SKIN:GetVariable('CurrentAccent')

    if accent == current then
        return
    end

    local variables = SKIN:GetVariable('@') .. 'Variables.inc'

    -- Guardar accent actual
    SKIN:Bang('!WriteKeyValue', 'Variables', 'CurrentAccent', accent, variables)

    -- Color1
    if SKIN:GetVariable('UseAccentColor1') == '1' then
        SKIN:Bang('!WriteKeyValue', 'Variables', 'Color1', accent, variables)
    end

    -- Color2
    if SKIN:GetVariable('UseAccentColor2') == '1' then
        SKIN:Bang('!WriteKeyValue', 'Variables', 'Color2', accent, variables)
    end

    -- Color3
    if SKIN:GetVariable('UseAccentColor3') == '1' then
        SKIN:Bang('!WriteKeyValue', 'Variables', 'Color3', accent, variables)
    end

    -- REFRESH COMPLETO
    SKIN:Bang('!RefreshApp')
end

function ToggleAccent(index)

    local var = 'UseAccentColor' .. index
    local current = tonumber(SKIN:GetVariable(var))

    local newValue = 1

    if current == 1 then
        newValue = 0
    end

    local variables = SKIN:GetVariable('@') .. 'Variables.inc'

    SKIN:Bang('!WriteKeyValue', 'Variables', var, newValue, variables)
    SKIN:Bang('!SetVariable', var, newValue)

    SKIN:Bang('!Refresh', '*')

end