# ⚠️ Important Setup Notes

## Each Project Needs Its Own Setup

**Each WordPress project should be in its own directory with its own:**
- Docker containers (with unique names and ports)
- Node modules (`npm install` in each project)
- Build output (webpack builds to that project's theme)

## Port Conflicts

If you have multiple projects (like AFCO and a new project):

1. **Stop other projects first:**
   ```bash
   # Stop AFCO
   cd /path/to/afco-website
   docker-compose down

   # Then start your new project
   cd /path/to/new-project
   docker-compose up -d
   ```

2. **Or use different ports:**
   - Edit `docker-compose.yml` in your new project
   - Change `8080:80` to `8082:80` (or any free port)
   - Change `8081:80` to `8083:80` (or any free port)
   - Access at: http://localhost:8082

## Directory Structure

Your new project should be completely separate:

```
/path/to/
├── afco-website/          # AFCO project
│   ├── docker-compose.yml
│   ├── package.json
│   └── ...
└── new-project/           # Your new project
    ├── docker-compose.yml  # Different ports!
    ├── package.json
    └── ...
```

## Quick Checklist

- [ ] New project is in its own directory
- [ ] Ports don't conflict with other projects
- [ ] Docker containers have unique names (PROJECT_NAME-wordpress)
- [ ] Webpack output path matches your theme name
- [ ] All placeholders replaced (YOUR_THEME_NAME, PROJECT_NAME, etc.)

