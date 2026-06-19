export default function () {
  this.route("user", { path: "/u/:username" }, function () {
    this.route("orcidPublications", { path: "/publications" });
  });
}