using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Web.Model;
using Web.Services;

namespace Web
{
    public partial class About : Page
    {
        protected async void Page_Load(object sender, EventArgs e)
        {
            if (Page.IsPostBack)
            {
                return;
            }
            loadData();
        }

        private async void loadData()
        {
            ApiService<AuthorModel, IEnumerable<AuthorModel>> a = new ApiService<AuthorModel, IEnumerable<AuthorModel>>();
            GenericResponse<IEnumerable<AuthorModel>> result = await a.CallService("Author", ApiService<AuthorModel, IEnumerable<AuthorModel>>.RequestType.GET, null);
            gvBook.DataSource = result.Data;
            gvBook.DataBind();
        }

        protected void btnCancel_Click(object sender, EventArgs e)
        {
            txtId.Text = "";
            txtName.Text = "";
            txtBirthdate.Text = "";
            txtCityOrigin.Text = "";
            txtEmail.Text = "";
            btnCancel.Visible = false;
        }

        protected void gvBook_RowEditing(object sender, GridViewEditEventArgs e)
        {
            e.Cancel = true;
        }

        protected void gvBook_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "Edit")
            {
                int rowIndex = int.Parse(e.CommandArgument.ToString());
                GridViewRow row = gvBook.Rows[rowIndex];
                txtId.Text = HttpUtility.HtmlDecode(row.Cells[0].Text);
                txtName.Text = HttpUtility.HtmlDecode(row.Cells[1].Text);
                txtBirthdate.Text = HttpUtility.HtmlDecode(Convert.ToDateTime(row.Cells[2].Text).ToString("yyyy-MM-dd"));
                txtCityOrigin.Text = HttpUtility.HtmlDecode(row.Cells[3].Text);
                txtEmail.Text = HttpUtility.HtmlDecode(row.Cells[4].Text);
                btnCancel.Visible = true;
            }
        }

        protected async void btnSave_Click(object sender, EventArgs e)
        {
            btnCancel.Visible = false;
            AuthorModel book = new AuthorModel()
            {
                Birthdate = DateTime.Parse(txtBirthdate.Text),
                CityOrigin = txtCityOrigin.Text,
                Email = txtEmail.Text,
                Id = txtId.Text == "" ? 0 : int.Parse(txtId.Text),
                Name = txtName.Text
            };
            ApiService<AuthorModel, AuthorModel> a = new ApiService<AuthorModel, AuthorModel>();
            ApiService<AuthorModel, AuthorModel>.RequestType requestType = book.Id > 0 ? ApiService<AuthorModel, AuthorModel>.RequestType.PUT : ApiService<AuthorModel, AuthorModel>.RequestType.POST;
            GenericResponse<AuthorModel> task = await a.CallService("Author", requestType, book);
            registerMessage<AuthorModel>(task);
            loadData();
            btnCancel_Click(sender, e);
        }

        protected async void btnDelete_Click(object sender, EventArgs e)
        {
            string id = txtId.Text;
            txtId.Text = "";
            if (string.IsNullOrEmpty(id))
            {
                return;
            }
            ApiService<int?, bool> a = new ApiService<int?, bool>();
            GenericResponse<bool> r = await a.CallService($"Author/delete/{id}", ApiService<int?, bool>.RequestType.DELETE, null);
            registerMessage<bool>(r);
            loadData();
        }

        private void registerMessage<T>(GenericResponse<T> result)
        {
            if (result.Error)
            {
                ClientScript.RegisterClientScriptBlock(result.GetType(), "error", "<script type='text/javascript'>Swal.fire({icon: 'error',text: '" + (result.Message ?? "").Replace("'", "\"") + "'})</script>");
                return;
            }
            ClientScript.RegisterClientScriptBlock(result.GetType(), "error", "<script type='text/javascript'>Swal.fire({icon: 'success',text: '" + (result.Message ?? "").Replace("'", "\"") + "'})</script>");
        }
    }
}