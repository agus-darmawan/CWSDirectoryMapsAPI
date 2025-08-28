# CwsDirectoryMapsApi

💧 A project built with the Vapor web framework.

## Getting Started

### Build the project
To build the project using the Swift Package Manager, run the following command in the terminal from the root of the project:
```bash
swift build
```

### Run the project
To run the project and start the server, use the following command:
```bash
swift run CwsDirectoryMapsApi serve
```

The server will start (default on port **8080**) and you can open:
```
http://127.0.0.1:8080
```

---

## Environment Variables

This project reads configuration from environment variables.  
Create a `.env` file in the root of the project:

```env
# Environment
ENV=development
PORT=8080
HOSTNAME=127.0.0.1

# Database
DATABASE_HOST=localhost
DATABASE_PORT=5432
DATABASE_USERNAME=postgres
DATABASE_PASSWORD=postgres
DATABASE_NAME=cws_directory_maps
```

Run the project with the `.env` file:
```bash
env $(cat .env | xargs) swift run CwsDirectoryMapsApi serve
```

---

## Development helper

You can create a `Makefile` for easier usage:

```make
dev:
	env $(cat .env | xargs) swift run CwsDirectoryMapsApi serve
```

Run with:
```bash
make dev
```

---

## Testing

To execute tests, use the following command:
```bash
swift test
```

---

### See more

- [Vapor Website](https://vapor.codes)
- [Vapor Documentation](https://docs.vapor.codes)
- [Vapor GitHub](https://github.com/vapor)
- [Vapor Community](https://github.com/vapor-community)
