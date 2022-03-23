import AdminAddUpload from "admin/controllers/modals/admin-add-upload";
import { inject as controller } from "@ember/controller";

export default AdminAddUpload.extend({
  adminCustomizeThemesShow: controller("user.themes.show"),
  uploadUrl: "/user_themes/upload_asset",
});
