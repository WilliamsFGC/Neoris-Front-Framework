<%@ Page Title="About" Async="true" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Author.aspx.cs" Inherits="Web.About" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="row">
        <div class="col-12">
            <div class="row">
                <div class="col-6 d-none">
                    <span>Id</span>
                    <asp:TextBox runat="server" ID="txtId" CssClass="form-control" onkeypress="return numbers(event)" onblur="validateValue(this)"></asp:TextBox>
                </div>
                <div class="col-6">
                    <span>Full name <span class="text-danger">*</span></span>
                    <asp:TextBox runat="server" ID="txtName" CssClass="form-control" MaxLength="100" onkeypress="return letters(event)" onblur="validateValue(this)"></asp:TextBox>
                    <span class="text-danger d-none">Full name is required</span>
                </div>
                <div class="col-6">
                    <span>Birthdate <span class="text-danger">*</span></span>
                    <asp:TextBox runat="server" ID="txtBirthdate" TextMode="Date" MaxLength="10" CssClass="form-control" onblur="validateValue(this)"></asp:TextBox>
                    <span class="text-danger d-none">Birthdate is required</span>
                </div>
                <div class="col-6">
                    <span>City origin <span class="text-danger">*</span></span>
                    <asp:TextBox runat="server" ID="txtCityOrigin" MaxLength="100" CssClass="form-control" onkeypress="return letters(event)" onblur="validateValue(this)"></asp:TextBox>
                    <span class="text-danger d-none">City origin is required</span>
                </div>
                <div class="col-6">
                    <span>Email <span class="text-danger">*</span></span>
                    <asp:TextBox runat="server" ID="txtEmail" MaxLength="100" CssClass="form-control" onblur="validateEmail()"></asp:TextBox>
                    <span class="text-danger d-none d-block w-100">Email is required</span>
                    <span class="text-danger text-email d-none d-block w-100">Email is invalid</span>
                </div>
                <div class="col-12 text-end mt-2">
                    <asp:Button ID="btnCancel" Text="Cancel" runat="server" CssClass="btn btn-secondary" Visible="false" OnClick="btnCancel_Click" />
                    <asp:Button ID="btnSave" Text="Save" runat="server" CssClass="btn btn-primary" OnClientClick="return validate()" OnClick="btnSave_Click" />
                </div>
            </div>
        </div>
        <div class="col-12 mt-1">
            <asp:GridView ID="gvBook" runat="server" AutoGenerateColumns="false" CssClass="table w-100" OnRowCommand="gvBook_RowCommand" OnRowEditing="gvBook_RowEditing">
                <Columns>
                    <asp:BoundField DataField="Id" HeaderText="Id" HeaderStyle-CssClass="bg-success text-light" />
                    <asp:BoundField DataField="Name" HeaderText="Full name" HeaderStyle-CssClass="bg-success text-light" />
                    <asp:BoundField DataField="Birthdate" HeaderText="Birthdate" HeaderStyle-CssClass="bg-success text-light" />
                    <asp:BoundField DataField="CityOrigin" HeaderText="City origin" HeaderStyle-CssClass="bg-success text-light" />
                    <asp:BoundField DataField="Email" HeaderText="Email" HeaderStyle-CssClass="bg-success text-light" />
                    <asp:TemplateField HeaderText="Action" HeaderStyle-CssClass="bg-success text-light">
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
            var txtEmail = $('#<%=txtEmail.ClientID%>');
            var txtBirthdate = $('#<%=txtBirthdate.ClientID%>');
            var txtCityOrigin = $('#<%=txtCityOrigin.ClientID%>');
            var txtName = $('#<%=txtName.ClientID%>');

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
                if (!control.value) {
                    valLabel.removeClass('d-none');
                    return false;
                }
                valLabel.addClass('d-none');
                return true;
            }

            function validateEmail() {
                var valid = true;
                if (!validateValue(txtEmail[0])) {
                    valid = false;
                }
                var textEmail = $(txtEmail[0].parentNode).find('.text-email');
                textEmail.removeClass('d-none');
                if (/^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/.test(txtEmail.val())) {
                    textEmail.addClass('d-none');
                }

                return valid;
            }

            function validate() {
                var valid = true;

                if (!validateEmail()) {
                    valid = false;
                }

                if (!validateValue(txtBirthdate[0])) {
                    valid = false;
                }

                if (!validateValue(txtCityOrigin[0])) {
                    valid = false;
                }

                if (!validateValue(txtName[0])) {
                    valid = false;
                }

                return valid;
            }

            function deleteItem(btn) {
                Swal.fire({
                    icon: 'question',
                    text: 'Do you want remove this author?',
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
