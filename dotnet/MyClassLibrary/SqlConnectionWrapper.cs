using Microsoft.Data.SqlClient;
using System.Data;

namespace MyClassLibrary;

public class SqlConnectionWrapper : IDbConnectionWrapper
{
    private readonly SqlConnection _sqlConnection;

    public SqlConnectionWrapper(SqlConnection sqlConnection)
    {
        _sqlConnection = sqlConnection;
    }

    public IDbCommand CreateCommand()
    {
        return _sqlConnection.CreateCommand();
    }

    public void Open()
    {
        _sqlConnection.Open();
    }

    public void Close()
    {
        _sqlConnection.Close();
    }
}
