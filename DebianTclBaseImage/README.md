## 🏷 Image Tagging Strategy

This project uses two types of tags for each Tcl major version:

### 1️⃣ Moving Tag (Latest in Major Line)

Example:

```
siqsuruq/tcl:tcl9-debian
```

This tag represents:

- Debian base image
- Latest available Tcl 9.x build

When a new Tcl 9 release is published (e.g. 9.0.4),
this tag will be updated to point to that newer version.

Use this tag if you want:
- Automatic updates within the same major version
- To always run the latest Tcl 9.x on Debian

Example:

```
docker pull siqsuruq/tcl:tcl9-debian
```

---

### 2️⃣ Pinned Version Tag (Immutable)

Example:

```
siqsuruq/tcl:9.0.3-debian
```

This tag represents:

- Debian base image
- Exact Tcl version (9.0.3)

Pinned tags never change once published.

Use this tag if you need:
- Reproducible builds
- Production stability
- Deterministic deployments

Example:

```
docker pull siqsuruq/tcl:9.0.3-debian
```

---

## 📦 Available Tag Patterns

| Tag | Meaning |
|------|---------|
| `tcl8-debian` | Latest Tcl 8.x on Debian |
| `8.6.17-debian` | Exact Tcl 8.6.17 on Debian |
| `tcl9-debian` | Latest Tcl 9.x on Debian |
| `9.0.3-debian` | Exact Tcl 9.0.3 on Debian |

---

## 🔎 Recommendation

- Use `tcl8-debian` or `tcl9-debian` for development.
- Use `8.x.x-debian` or `9.x.x-debian` for production.