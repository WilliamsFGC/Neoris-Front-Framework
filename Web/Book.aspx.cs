using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Web.Model;
using Web.Services;

namespace Web
{
    public partial class _Default : Page
    {
        protected async void Page_Load(object sender, EventArgs e)
        {
            if (Page.IsPostBack)
            {
                return;
            }
            loadData();
            LoadAuthors();
        }

        private async void loadData()
        {
            ApiService<IEnumerable<BookResponseModel>, IEnumerable<BookResponseModel>> a = new ApiService<IEnumerable<BookResponseModel>, IEnumerable<BookResponseModel>>();
            GenericResponse<IEnumerable<BookResponseModel>> result = await a.CallService("Book", ApiService<IEnumerable<BookResponseModel>, IEnumerable<BookResponseModel>>.RequestType.GET, null);
            gvBook.DataSource = result.Data ?? new List<BookResponseModel>();
            gvBook.DataBind();
            if (result.Error)
            {
                registerMessage<IEnumerable<BookResponseModel>>(result);
            }
        }

        private async void LoadAuthors()
        {
            ApiService<AuthorModel, IEnumerable<AuthorModel>> a = new ApiService<AuthorModel, IEnumerable<AuthorModel>>();
            GenericResponse<IEnumerable<AuthorModel>> result = await a.CallService("Author", ApiService<AuthorModel, IEnumerable<AuthorModel>>.RequestType.GET, null);
            IEnumerable<AuthorModel> items = result.Data ?? new List<AuthorModel>();
            ((List<AuthorModel>)items).Insert(0, new AuthorModel() { Id = 0 });
            cmbAuthor.DataSource = items;
            cmbAuthor.DataTextField = "Name";
            cmbAuthor.DataValueField = "Id";
            cmbAuthor.DataBind();
            if (result.Error)
            {
                registerMessage<IEnumerable<AuthorModel>>(result);
            }
        }

        protected async void btnSave_Click(object sender, EventArgs e)
        {
            btnCancel.Visible = false;
            BookModel book = new BookModel()
            {
                Genre = txtGenre.Text,
                Id = string.IsNullOrEmpty(txtId.Text) ? 0 : int.Parse(txtId.Text),
                Pages = int.Parse(txtPages.Text),
                Title = txtTitle.Text,
                Year = int.Parse(txtYear.Text),
                AuthorId = int.Parse(cmbAuthor.SelectedValue)
            };
            ApiService<BookModel, BookModel> a = new ApiService<BookModel, BookModel>();
            ApiService<BookModel, BookModel>.RequestType requestType = book.Id > 0 ? ApiService<BookModel, BookModel>.RequestType.PUT : ApiService<BookModel, BookModel>.RequestType.POST;
            GenericResponse<BookModel> task = await a.CallService("/Book", requestType, book);
            registerMessage<BookModel>(task);
            loadData();
            btnCancel_Click(sender, e);
        }

        protected void btnCancel_Click(object sender, EventArgs e)
        {
            txtGenre.Text = "";
            txtId.Text = "";
            txtPages.Text = "";
            txtTitle.Text = "";
            txtYear.Text = "";
            cmbAuthor.SelectedValue = null;
            btnCancel.Visible = false;
        }

        protected void gvBook_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "Edit")
            {
                int rowIndex = int.Parse(e.CommandArgument.ToString());
                GridViewRow row = gvBook.Rows[rowIndex];
                txtId.Text = HttpUtility.HtmlDecode(row.Cells[0].Text);
                txtTitle.Text = HttpUtility.HtmlDecode(row.Cells[1].Text);
                txtYear.Text = HttpUtility.HtmlDecode(row.Cells[2].Text);
                txtGenre.Text = HttpUtility.HtmlDecode(row.Cells[3].Text);
                txtPages.Text = HttpUtility.HtmlDecode(row.Cells[4].Text);
                cmbAuthor.SelectedValue = HttpUtility.HtmlDecode(row.Cells[5].Text);
                btnCancel.Visible = true;
            }
        }

        protected void gvBook_RowEditing(object sender, GridViewEditEventArgs e)
        {
            gvBook.EditIndex = -1;
            e.Cancel = true;
        }

        protected void gvBook_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            gvBook.EditIndex = -1;
            gvBook.DataBind();
        }

        protected void gvBook_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            e.Cancel = true;
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
            GenericResponse<bool> r = await a.CallService($"Book/{id}", ApiService<int?, bool>.RequestType.DELETE, null);
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