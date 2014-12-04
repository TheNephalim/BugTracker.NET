<%@ Page language="C#" CodeBehind="delete_udf.aspx.cs" Inherits="btnet.delete_udf" AutoEventWireup="True" %>
<%@ Register Src="~/Controls/MainMenu.ascx" TagPrefix="uc1" TagName="MainMenu" %>
<!--
Copyright 2002-2011 Corey Trager
Distributed under the terms of the GNU General Public License
-->
<!-- #include file = "inc.aspx" -->

<script language="C#" runat="server">

SQLString sql;


void Page_Init (object sender, EventArgs e) {ViewStateUserKey = Session.SessionID;}

///////////////////////////////////////////////////////////////////////
void Page_Load(Object sender, EventArgs e)
{

	Util.do_not_cache(Response);


	if (IsPostBack)
	{
		// do delete here
		sql = new SQLString(@"delete user_defined_attribute where udf_id = @udfid");
        sql = sql.AddParameterWithValue("udfid", Util.sanitize_integer(row_id.Value));
		btnet.DbUtil.execute_nonquery(sql);
		Server.Transfer ("udfs.aspx");
	}
	else
	{
		titl.InnerText = Util.get_setting("AppTitle","BugTracker.NET") + " - "
			+ "delete user defined attribute value";

		string id = Util.sanitize_integer(Request["id"]);

		sql = new SQLString(@"declare @cnt int
			select @cnt = count(1) from bugs where bg_user_defined_attribute = @udfid
			select udf_name, @cnt [cnt] from user_defined_attribute where udf_id = @udfid");
		sql = sql.AddParameterWithValue("udfid", id);

		DataRow dr = btnet.DbUtil.get_datarow(sql);

		if ((int) dr["cnt"] > 0)
		{
			Response.Write ("You can't delete value \""
				+ Convert.ToString(dr["udf_name"])
				+ "\" because some bugs still reference it.");
			Response.End();
		}
		else
		{
			confirm_href.InnerText = "confirm delete of \""
				+ Convert.ToString(dr["udf_name"])
				+ "\"";

			row_id.Value = id;
		}

	}

}

</script>

<html>
<head>
<title id="titl" runat="server">btnet delete user defined attribute value</title>
<link rel="StyleSheet" href="btnet.css" type="text/css">
</head>
<body>
<uc1:MainMenu runat="server" ID="MainMenu" SelectedItem="admin"/>
<p>
<div class=align>
<p>&nbsp</p>
<a href=udfs.aspx>back to user defined attribute values</a>

<p>or<p>

<script>
function submit_form()
{
    var frm = document.getElementById("frm");
    frm.submit();
    return true;
}

</script>
<form runat="server" id="frm">
<a id="confirm_href" runat="server" href="javascript: submit_form()"></a>
<input type="hidden" id="row_id" runat="server">
</form>

</div>
<% Response.Write(Application["custom_footer"]); %></body>
</html>


