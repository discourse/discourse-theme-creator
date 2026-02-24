import ThemeTranslation from "discourse/admin/components/theme-translation";
import { url } from "discourse/lib/computed";

export default class UserThemeTranslation extends ThemeTranslation {
  @url("model.id", "/user_themes/%@") updateUrl;
}
