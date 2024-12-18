using System.Data;

namespace MyClassLibrary;

public interface IDbConnectionWrapper
{
    IDbCommand CreateCommand();
    void Open();
    void Close();
}
