<%@ Page Language="vb" AutoEventWireup="true" CodeFile="Default.aspx.vb" Inherits="_Default" %>

<%@ Register assembly="DevExpress.Web.v17.1, Version=17.1.4.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" namespace="DevExpress.Web" tagprefix="dx" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Upload page</title>
    <style>
        .upload-validationInfo 
        {
            font: 8pt Tahoma, Geneva, sans-serif;
        }
        .popup-okButton
        {
            margin: 6px 6px 6px 210px;
        }
        .error-attention 
        {
            text-decoration: underline;
            font-weight: bold;
        }
        .error-detail 
        {
            color: #FF0000;
        }
        .error-file 
        {
            background: #FFC8C8 none;
            font-style: italic;
        }
    </style>
    <script type="text/javascript">
        function onUploadControlValidationErrorOccured(s, e) {
            e.showAlert = false;

            var htmlContentTemplate = "<div class='error-attention'>Attention!</div><br />" +
                "{0} files are invalid and will not be uploaded.<br /><br /> {1}" +
                "All files listed above have been removed from the selection.";

            var htmlContent = htmlContentTemplate
                .replace("{0}", e.invalidFiles.length)
                .replace("{1}", getErrorInfoHtml(e));

            popupControl.SetContentHtml(htmlContent);
            popupControl.Show();
        }
        function getErrorInfoHtml(e) {
            var html = "";

            html += getDetailsErrorInfoHtml(e, ASPxClientUploadControlValidationErrorTypeConsts.MaxFileCountExceeded,
                "These file(s) exceed the limit of files to be uploaded at once (which is set to {0}):",
                e.validationSettings.maxFileCount);

            html += getDetailsErrorInfoHtml(e, ASPxClientUploadControlValidationErrorTypeConsts.MaxFileSizeExceeded,
                "These files exceed the allowed file size (which is set to {0} bytes):",
                e.validationSettings.maxFileSize, true);

            html += getDetailsErrorInfoHtml(e, ASPxClientUploadControlValidationErrorTypeConsts.NotAllowedFileExtension,
                "Extensions of this files are not allowed (valid extensions are - {0}):",
                e.validationSettings.allowedFileExtensions.join(', '));

            html += getDetailsErrorInfoHtml(e, ASPxClientUploadControlValidationErrorTypeConsts.FileNameContainInvalidCharacter,
                "Names of this files are containing invalid characters ({0}):",
                e.validationSettings.invalidFileNameCharacters.join(","));

            return html;
        }
        function getDetailsErrorInfoHtml(e, errorType, message, validationInfo, showFileSize) {
            var filesInfo = getFilesInfoByErrorType(e.invalidFiles, errorType);
            if(filesInfo.length == 0)
                return "";

            var filesHtml = getFilesInfoHtml(filesInfo, showFileSize);
            message = message.replace("{0}", validationInfo);

            var result = "<div class='error-detail'>";
            result += message + "<br />";
            result += filesHtml + "<br />";
            result += "</div>";
            return result;
        }
        function getFilesInfoHtml(filesInfo, showFileSize) {
            var result = "<ul>";
            for(var i = 0, len = filesInfo.length; i < len; i++) {
                var f = filesInfo[i];
                var fileText = showFileSize ? f.fileName + " - " + f.fileSize + " bytes" : f.fileName;
                result += "<li class='error-file'>" + fileText + "</li>";
            }
            result += "</ul>";
            return result;
        }
        function getFilesInfoByErrorType(invalidFiles, errorType) {
            var filesInfo = [];
            for(var i = 0, len = invalidFiles.length; i < len; i++) {
                var fileInfo = invalidFiles[i];
                if(fileInfo.errorType == errorType)
                    filesInfo.push(fileInfo);
            }
            return filesInfo;
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <dx:ASPxUploadControl ID="UploadControl" runat="server" Width="320"
            NullText="Select multiple files..." UploadMode="Advanced" ShowUploadButton="True">
            <AdvancedModeSettings EnableMultiSelect="True" EnableFileList="True" />
            <ValidationSettings MaxFileSize="4194304" AllowedFileExtensions=".jpg,.jpeg" MaxFileCount="4" />
            <ClientSideEvents ValidationErrorOccurred="onUploadControlValidationErrorOccured" />
        </dx:ASPxUploadControl>
        <br />
        <div class="upload-validationInfo">Allowed file extensions: .jpg, .jpeg</div>
        <div class="upload-validationInfo">Maximum file size: 4 MB.</div>
        <div class="upload-validationInfo">Maximum file count: 4 files</div>

        <dx:ASPxPopupControl runat="server" ID="PopupControl" ClientInstanceName="popupControl" Modal="true" HeaderText="Validation error"
            PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter"
            ShowCloseButton="true" CloseAction="CloseButton" ShowFooter="true">
            <FooterTemplate>
                <dx:ASPxButton ID="OkButton" runat="server" Text="OK" AutoPostBack="False"
                    Width="90" CssClass="popup-okButton"
                    ClientSideEvents-Click="function(s, e) { popupControl.Hide(); }" />
            </FooterTemplate>
        </dx:ASPxPopupControl>
    </div>
    </form>
</body>
</html>