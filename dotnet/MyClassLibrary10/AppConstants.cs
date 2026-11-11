namespace MyClassLibrary10;

/// <summary>
/// Constants used throughout the library.
/// </summary>
public static class AppConstants
{
    /// <summary>
    /// Configuration section and key names.
    /// </summary>
    public static class Configuration
    {
        /// <summary>
        /// Connection string key for the main database.
        /// </summary>
        public const string DbConnectionKey = "ConnectionStrings:MyDatabase";

        /// <summary>
        /// Connection string key for Azure Table Storage.
        /// </summary>
        public const string AzureConnectionKey = "ConnectionStrings:MyAzureStorage";

        /// <summary>
        /// Configuration key for general application configuration.
        /// </summary>
        public const string MyConfigurationKey = "MyConfiguration";

        /// <summary>
        /// Configuration key for secrets.
        /// </summary>
        public const string MySecretKey = "MySecret";
    }

    /// <summary>
    /// Feature management flag names.
    /// </summary>
    public static class Features
    {
        /// <summary>
        /// Feature flag for enabling data saving functionality.
        /// </summary>
        public const string MySaveFeature = "MyFeature";
    }

    /// <summary>
    /// Database schema and table names.
    /// </summary>
    public static class Database
    {
        /// <summary>
        /// Standard date format for partition keys (yyyy-MM-dd).
        /// </summary>
        public const string PartitionKeyDateFormat = "yyyy-MM-dd";

        /// <summary>
        /// Table name for storing data.
        /// </summary>
        public const string TableName = "MyTable";

        /// <summary>
        /// Partition key column name.
        /// </summary>
        public const string PartitionKeyColumn = "PartitionKey";

        /// <summary>
        /// Row key column name.
        /// </summary>
        public const string RowKeyColumn = "RowKey";

        /// <summary>
        /// Data column name.
        /// </summary>
        public const string DataColumn = "MyInput";

        /// <summary>
        /// SQL insert statement template.
        /// </summary>
        public const string InsertStatement = $"INSERT [dbo].[{TableName}] ([{PartitionKeyColumn}], [{RowKeyColumn}], [{DataColumn}]) VALUES (@{PartitionKeyColumn}, @{RowKeyColumn}, @{DataColumn});";
    }

    /// <summary>
    /// Azure Table Storage configuration.
    /// </summary>
    public static class AzureTable
    {
        /// <summary>
        /// Table name in Azure Table Storage.
        /// </summary>
        public const string TableName = "MyCloudTable";

        /// <summary>
        /// Development connection string indicator.
        /// </summary>
        public const string DevelopmentConnectionString = "UseDevelopmentStorage=true;";
    }
}
