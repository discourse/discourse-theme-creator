import Theme from "admin/models/theme";
import { url } from "discourse/lib/computed";

export default Theme.extend({
  diffLocalChangesUrl: url("id", "/user_themes/%@/diff_local_changes"),
});
