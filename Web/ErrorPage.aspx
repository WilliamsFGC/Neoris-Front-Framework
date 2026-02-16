<%@ Page Title="Contact" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ErrorPage.aspx.cs" Inherits="Web.Contact" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <main aria-labelledby="title">
        <h2 id="title"><%: Title %>.</h2>
        <h3>An error has occurred in the system</h3>
        <address>
            William Garzón Castro<br />
            Bogotá D.C<br />
            <abbr title="Phone">P: +57 313 867 7654</abbr>
        </address>

        <address>
            <strong>Support:</strong>   <a href="mailto:robiespiere14@hotmail.com">robiespiere14@hotmail.com</a><br />
        </address>
    </main>
</asp:Content>
