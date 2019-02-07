#実行環境に合わせて書き換え
#Microsoft.SharePointOnline.CSOM
#https://www.nuget.org/packages/Microsoft.SharePointOnline.CSOM/
Add-Type -Path "C:\Program Files\PackageManagement\NuGet\Packages\Microsoft.SharePointOnline.CSOM.16.1.7018.1200\lib\net40-full\Microsoft.SharePoint.Client.dll"

$url = "https://<tenant>.sharepoint.com/sites/<sitename>"
$ctx = New-Object Microsoft.SharePoint.Client.ClientContext($url)
$user = Read-Host -Prompt "Enter Sign-in User Name"
$pass = Read-Host -Prompt "Enter Password" -AsSecureString
$cred = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($user, $pass)
$ctx.Credentials = $cred

$listName = "<Listname>"
$list = $ctx.Web.Lists.getByTitle($listName)

for($i=0; $i -lt 19999; $i++)
{
    $itemCreateInfo = New-Object Microsoft.SharePoint.Client.ListItemCreationInformation
    $listItem = $list.addItem($itemCreateInfo)
    $listItem.set_item('Title', 'ITEM-No. ' + $i)
    $listItem.set_item('Column1', 'COLUMN1-No. ' + $i.ToString("00000"))
    $listItem.Update()
    $ctx.Load($listItem)

    if($i%200 -eq 0)
    {
        $ctx.ExecuteQuery()
        Write-Host 'Added Items!!! ' + $i
    }
}
$ctx.ExecuteQuery()
