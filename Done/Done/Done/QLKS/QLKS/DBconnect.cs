using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace QLKS
{
    internal class DBConnect
    {
        SqlConnection conn = new SqlConnection("Data Source=.\\sqlexpress;Initial Catalog=QL_KHACHSAN2;Integrated Security=True");

        public DBConnect()
        {

        }
        public void Open()
        {
            if (conn.State == ConnectionState.Closed)
            {
                conn.Open();
            }

        }
        public void Close()
        {
            if (conn.State == ConnectionState.Open)
            {
                conn.Close();
            }
        }

        public int getNonQuery(string sql)
        {
            int result = 0;
            try
            {
                using (SqlConnection conn = new SqlConnection("Data Source=.\\sqlexpress;Initial Catalog=QL_KHACHSAN2;Integrated Security=True"))
                {
                    conn.Open();
                    using (SqlCommand cmd = new SqlCommand(sql, conn))
                    {
                        result = cmd.ExecuteNonQuery();
                    }
                }
            }
            catch (SqlException ex)
            {
                // Log exception details or display them as needed
                Console.WriteLine("SQL Error: " + ex.Message);
            }
            catch (Exception ex)
            {
                // Log exception details or display them as needed
                Console.WriteLine("General Error: " + ex.Message);
            }
            return result;
        }


        public object getScalar(string sql)
        {
            string connectionString = "Data Source=.\\sqlexpress;Initial Catalog=QL_KHACHSAN2;Integrated Security=True;";

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                try
                {
                    conn.Open();
                    using (SqlCommand cmd = new SqlCommand(sql, conn))
                    {
                        object result = cmd.ExecuteScalar();
                        return result;
                    }
                }
                catch (SqlException ex)
                {
                    // Handle exception
                    Console.WriteLine("SQL Error: " + ex.Message);
                    return null;
                }
                catch (Exception ex)
                {
                    // Handle general exception
                    Console.WriteLine("Error: " + ex.Message);
                    return null;
                }
            }
        }


        public DataTable getTable(string sql)
        {
            DataTable dataTable = new DataTable();
            try
            {
                using (SqlConnection conn = new SqlConnection("Data Source=.\\sqlexpress;Initial Catalog=QL_KHACHSAN2;Integrated Security=True;"))
                {
                    using (SqlDataAdapter da = new SqlDataAdapter(sql, conn))
                    {
                        conn.Open();
                        da.Fill(dataTable);
                    }
                }
            }
            catch (SqlException ex)
            {
                // Log exception details or display them as needed
                Console.WriteLine("SQL Error: " + ex.Message);
            }
            catch (Exception ex)
            {
                // Log exception details or display them as needed
                Console.WriteLine("General Error: " + ex.Message);
            }
            return dataTable;
        }

        public int updateTable(DataTable dtnew, string chuoitruyvan)
        {
            SqlDataAdapter da = new SqlDataAdapter(chuoitruyvan, conn);//dữ liệu cũ chưa cập nhật
            SqlCommandBuilder cb = new SqlCommandBuilder(da);
            int kq = da.Update(dtnew);
            return kq;
        }



    }
}
