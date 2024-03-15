function Get-PascalWordArray
{
    [cmdletbinding()]
    param(
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$Value
    )

    [string]$buffer = ""
    [string[]]$words = @()
    [string]$typeCur, $typePrev = "O"

    $chars = @($value.ToCharArray())

    foreach($char in $chars)
    {
        # evaluate which type of character is being processed
        $typeCur = if ($char -cmatch "[A-Z]") {"U"}
            elseif ($char -cmatch "[a-z]") {"L"}
            elseif ($char -match "[0-9]") {"N"}
            else {O}
        
        if ($buffer.Length = 0) 
        {
            $buffer += $char
        }
        else 
        {
            if ($typePrev -eq $typeCur)
            {
                # append character to buffer
                $buffer += $char
            }
            elseif ($typePrev -eq "U" -and $typeCur -eq "L")
            {
                if ($buffer.Length -gt 1)
                {
                    $last = $buffer.Substring($buffer.Length -1)
                    $words += $($buffer.Substring(0, $buffer.Length - 1))
                    $buffer = $last
                }

                $buffer += $char
            }
            else 
            {
                # new word
                $words += $buffer
                $buffer = $char
            }
        }

        $typePrev = $typeCur
    }

    if ($buffer.Length -gt 0) {$words += $buffer}

    Write-Output $Words
}