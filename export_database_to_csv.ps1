# Step 1: Downnload database backup from the server
# Step 2: Restore the database on your local machine
# Step 3: Update the database name which you want to export
# Step 4: Run the script below to export all tables to csv files

# Update the following variables to match your environment
#$database = "mesdb"
# $database = "WebDB"
# $database = "ECS"
# $database = "Excell"
$database = "NA.MIS"
# $database = "NAPIECS"
#  $database = "VA.MIS"
# $database = "vitaaidmis"

# create a folder named by database name
$base_path = "D:\sql_export\"
$export_folder = $base_path + $database
New-Item -ItemType Directory  -Path $export_folder

# connection string builder
$server = "192.168.124.17"
$username = "sa"
$password = "mesuser"

$tablequery = "SELECT s.name as schemaName, t.name as tableName from sys.tables t inner join sys.schemas s ON t.schema_id = s.schema_id"
 
#Delcare Connection Variables
$connectionTemplate = "Data Source={0};Initial Catalog={1};User ID={2};Password={3};"
$connectionString = [string]::Format($connectionTemplate, $server, $database, $username, $password)
$connection = New-Object System.Data.SqlClient.SqlConnection
$connection.ConnectionString = $connectionString
 
$command = New-Object System.Data.SqlClient.SqlCommand
$command.CommandText = $tablequery
$command.Connection = $connection
 
#Load up the Tables in a dataset
$SqlAdapter = New-Object System.Data.SqlClient.SqlDataAdapter
$SqlAdapter.SelectCommand = $command
$DataSet = New-Object System.Data.DataSet
$SqlAdapter.Fill($DataSet)
$connection.Close()
 
 
 
# Loop through all tables and export a CSV of the Table Data
foreach ($Row in $DataSet.Tables[0].Rows) {
    $queryData = "SELECT * FROM [$($Row[0])].[$($Row[1])]"
     
    #Specify the output location of your dump file
    $extractFile = $export_folder + "\$($Row[0])_$($Row[1]).csv"
     
    $command.CommandText = $queryData
    $command.Connection = $connection
 
    $SqlAdapter = New-Object System.Data.SqlClient.SqlDataAdapter
    $SqlAdapter.SelectCommand = $command
    $DataSet = New-Object System.Data.DataSet
    $SqlAdapter.Fill($DataSet)
    $connection.Close()
 
    $DataSet.Tables[0]  | Export-Csv $extractFile -NoTypeInformation
}

Invoke-Item -Path "D:\sql_export\"
