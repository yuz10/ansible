
# This particular file snippet, and this file snippet only, is BSD licensed.
# Modules you write using this snippet, which is embedded dynamically by Ansible
# still belong to the author of the module, and may assign their own license
# to the complete work.
#
# Copyright (c), Michael DeHaan <michael.dehaan@gmail.com>, 2014, and others
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without modification,
# are permitted provided that the following conditions are met:
#
#    * Redistributions of source code must retain the above copyright
#      notice, this list of conditions and the following disclaimer.
#    * Redistributions in binary form must reproduce the above copyright notice,
#      this list of conditions and the following disclaimer in the documentation
#      and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
# IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
# INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
# PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
# LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
# USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#

# Helper function to parse Ansible JSON arguments from a file passed as
# the single argument to the module
Function Parse-Args($arguments)
{
    $parameters = New-Object psobject;
    If ($arguments.Length -gt 0)
    {
        $parameters = Get-Content $arguments[0] | ConvertFrom-Json;
    }
    $parameters;
}

# Helper function to set an "attribute" on a psobject instance in powershell.
# This is a convenience to make adding Members to the object easier and
# slightly more pythonic
Function Set-Attr($obj, $name, $value)
{
    $obj | Add-Member -Force -MemberType NoteProperty -Name $name -Value $value
}

# Helper function to get an "attribute" from a psobject instance in powershell.
# This is a convenience to make getting Members from an object easier and
# slightly more pythonic
# Example: $attr = Get-Attr $response "code" -default "1"
Function Get-Attr($obj, $name, $default = $null)
{
    If ($obj.$name.GetType)
    {
        $obj.$name
    }
    Else
    {
        $default
    }
    return
}

# Helper function to convert a powershell object to JSON to echo it, exiting
# the script
Function Exit-Json($obj)
{
    echo $obj | ConvertTo-Json
    Exit
}

# Helper function to add the "msg" property and "failed" property, convert the
# powershell object to JSON and echo it, exiting the script
Function Fail-Json($obj, $message)
{
    Set-Attr $obj "msg" $message
    Set-Attr $obj "failed" $true
    echo $obj | ConvertTo-Json
    Exit 1
}

# Helper filter/pipeline function to convert a value to boolean following current
# Ansible practices
Function ConvertTo-Bool
{
    param(
        [parameter(valuefrompipeline=$true)]
        $obj
    )

    $boolean_strings = "yes", "on", "1", "true", 1
    $obj_string = [string]$obj

    if (($obj.GetType().Name -eq "Boolean" -and $obj) -or $boolean_strings -contains $obj_string.ToLower())
    {
        $true
    }
    Else
    {
        $false
    }
    return
}
