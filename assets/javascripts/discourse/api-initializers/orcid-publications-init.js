import { apiInitializer } from "discourse/lib/api";

export default apiInitializer("1.15.0", (api) => {
  api.addRoutes("user", function () {
    this.route("orcidPublications", { path: "/publications" });
  });
});