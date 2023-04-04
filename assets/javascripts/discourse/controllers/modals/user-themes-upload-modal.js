import AdminAddUpload from "admin/controllers/modals/admin-add-upload";
import { inject as controller } from "@ember/controller";

export default class UserThemesUploadModal extends AdminAddUpload {
  @controller("user.themes.show") adminCustomizeThemesShow;
  uploadUrl = "/user_themes/upload_asset";
}
