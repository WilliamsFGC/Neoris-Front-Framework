<%@ Page Title="Home Page" Async="true" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Book.aspx.cs" Inherits="Web._Default" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <div class="row">
        <div class="col-12">
            <div class="row">
                <div class="col-6 d-none">
                    <span>Id</span>
                    <asp:TextBox CssClass="form-control" runat="server" ID="txtId" onkeypress="return numbers(event)"></asp:TextBox>
                </div>
                <div class="col-6">
                    <span>Title <span class="text-danger">*</span></span>
                    <asp:TextBox MaxLength="100" CssClass="form-control" runat="server" ID="txtTitle" onkeypress="return alphaNumeric(event)" onblur="validateValue(this)"></asp:TextBox>
                    <span class="text-danger d-none">Title is required</span>
                </div>
                <div class="col-6">
                    <span>Year <span class="text-danger">*</span></span>
                    <asp:TextBox MaxLength="4" CssClass="form-control" runat="server" ID="txtYear" onkeypress="return numbers(event)" onblur="validateValue(this)"></asp:TextBox>
                    <span class="text-danger d-none">Year is required</span>
                </div>
                <div class="col-6">
                    <span>Genre <span class="text-danger">*</span></span>
                    <asp:TextBox MaxLength="50" CssClass="form-control" runat="server" ID="txtGenre" onkeypress="return letters(event)" onblur="validateValue(this)"></asp:TextBox>
                    <span class="text-danger d-none">Genre is required</span>
                </div>
                <div class="col-6">
                    <span>Number pages <span class="text-danger">*</span></span>
                    <asp:TextBox MaxLength="10" CssClass="form-control" runat="server" ID="txtPages" onkeypress="return numbers(event)" onblur="validateValue(this)"></asp:TextBox>
                    <span class="text-danger d-none">Number pages is required</span>
                </div>
                <div class="col-6">
                    <span>Author <span class="text-danger">*</span></span>
                    <asp:DropDownList CssClass="form-control" runat="server" ID="cmbAuthor" onblur="validateValue(this)"></asp:DropDownList>
                    <span class="text-danger d-none">Author is required</span>
                </div>
                <div class="col-12 my-2 text-end">
                    <asp:Button ID="btnCancel" Text="Cancel" runat="server" CssClass="btn btn-secondary" Visible="false" OnClick="btnCancel_Click" />
                    <asp:Button ID="btnSave" Text="Save" runat="server" CssClass="btn btn-primary" OnClick="btnSave_Click" OnClientClick="return validate()" />
                </div>
            </div>
        </div>
        <div class="col-12 mt-1">
            <asp:GridView runat="server" ID="gvBook" AutoGenerateColumns="false" CssClass="table w-100" OnRowDeleting="gvBook_RowDeleting" OnRowCommand="gvBook_RowCommand" OnRowEditing="gvBook_RowEditing" OnRowCancelingEdit="gvBook_RowCancelingEdit">
                <Columns>
                    <asp:BoundField DataField="Id" HeaderText="Id" HeaderStyle-CssClass="bg-success text-light" />
                    <asp:BoundField DataField="Title" HeaderText="Title" HeaderStyle-CssClass="bg-success text-light" />
                    <asp:BoundField DataField="Year" HeaderText="Year" HeaderStyle-CssClass="bg-success text-light" />
                    <asp:BoundField DataField="Genre" HeaderText="Genre" HeaderStyle-CssClass="bg-success text-light" />
                    <asp:BoundField DataField="Pages" HeaderText="Number pages" HeaderStyle-CssClass="bg-success text-light" />
                    <asp:BoundField DataField="AuthorId" HeaderText="AuthorId" HeaderStyle-CssClass="bg-success text-light d-none" ItemStyle-CssClass="d-none" />
                    <asp:BoundField DataField="AuthorName" HeaderText="Author" HeaderStyle-CssClass="bg-success text-light" />
                    <asp:TemplateField HeaderText="" HeaderStyle-CssClass="bg-success text-light">
                        <ItemTemplate>
                            <asp:Button ID="btnSelect" runat="server" CommandName="Edit" CommandArgument='<%# Container.DataItemIndex %>' Text="&#xf044;" CssClass="fa text-primary btn" />
                            <asp:Button ID="btnDelete" runat="server" CommandName="Delete" CommandArgument='<%# Container.DataItemIndex %>' Text="&#xf1f8;" CssClass="fa text-danger btn" OnClientClick="return deleteItem(this)" />
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
            <asp:Button ID="btnDelete" OnClick="btnDelete_Click" CssClass="d-none" runat="server" />
        </div>
        <script type="text/javascript">
            var txtId = $('#<%=txtId.ClientID%>');
            var txtTitle = $('#<%=txtTitle.ClientID%>');
            var txtYear = $('#<%=txtYear.ClientID%>');
            var txtGenre = $('#<%=txtGenre.ClientID%>');
            var txtPages = $('#<%=txtPages.ClientID%>');
            var cmbAuthor = $('#<%=cmbAuthor.ClientID%>');

            function numbers(e) {
                if (!/[0-9]/.test(e.key)) {
                    e.preventDefault();
                    return false;
                }
                return true;
            }

            function letters(e) {
                if (!/[a-zA-Z ]/.test(e.key)) {
                    e.preventDefault();
                    return false;
                }
                return true;
            }

            function alphaNumeric(e) {
                if (!/[a-zA-Z0-9 ]/.test(e.key)) {
                    e.preventDefault();
                    return false;
                }
                return true;
            }

            function validateValue(control) {
                const parent = control.parentNode;
                const valLabel = $(parent).find('.text-danger');
                if (!control.value || control.value == '0') {
                    valLabel.removeClass('d-none');
                    return false;
                }
                valLabel.addClass('d-none');
                return true;
            }

            function validate() {
                var valid = true;
                if (!validateValue(txtTitle[0])) {
                    valid = false;
                }

                if (!validateValue(txtYear[0])) {
                    valid = false;
                }

                if (!validateValue(txtGenre[0])) {
                    valid = false;
                }

                if (!validateValue(txtPages[0])) {
                    valid = false;
                }

                if (!validateValue(cmbAuthor[0])) {
                    valid = false;
                }

                return valid;
            }

            function deleteItem(btn) {
                Swal.fire({
                    icon: 'question',
                    text: 'Do you want remove this book?',
                    confirmButtonText: 'Accept',
                    showCancelButton: true
                }).then(r => {
                    if (r.isConfirmed) {
                        $('#<%=txtId.ClientID%>').val(btn.parentNode.parentNode.cells[0].innerText);
                        $('#<%=btnDelete.ClientID %>').click();
                    }
                });

                return false;
            }
        </script>

    </div>
</asp:Content>
