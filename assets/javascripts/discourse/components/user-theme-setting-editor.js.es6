import ThemeSettingEditor from "admin/components/theme-setting-editor";
import { url } from "discourse/lib/computed";

export default ThemeSettingEditor.extend({
  updateUrl: url("model.id", "/user_themes/%@/setting")
});
