# URL Shortener

A simple URL shortener made with Ruby & Sinatra

## Start the server
```bash
docker-compose up
```
Server is running on [localhost:8080](http://localhost:8080)

## Alternatively, run manually with
### Environment variables
```bash
APP_ENV=production
NANOID_SIZE=11 # Length of short-URLs

REDIS_URL=redis://localhost:6379
DATABASE_HOST=localhost:5432
DATABASE_NAME=postgres
DATABASE_USER=postgres
DATABASE_PASSWORD=postgres
```
### Startup
```bash
bundle install
bundle exec rake db:migrate
bundle exec puma -p 80
```

---

## Development

Clone the repository and open the Dev Container in VSCode, run
```bash
bundle exec rake db:migrate
bundle exec puma
```
Development server will be forwarded to [localhost:9292](http://localhost:9292)

### Run tests
```bash
bundle exec rake spec:all
```

---

## API Reference

### Redirect
> ```http
> GET /{url}
> ```
> 
> | Parameter | Type | Description |
> | :--- | :--- | :--- |
> | `json` | `"true"\|"false"` | Return JSON response, otherwise redirects |
> 
> **JSON Response**
> 
> ```javascript
> {
>   "exists": boolean,
>   "target": string
> }
> ```
> 
> The `exists` attribute is true if the URL exists.
> 
> The `target` attribute is the destination URL, to be used for redirecting.
> 
> **NOTE:** Status code `404` is returned if the URL does not exist.

### Shorten URL
> ```http
> POST /
> ```
> 
> | Parameter | Type | Description |
> | :--- | :--- | :--- |
> | `response_html` | `"true"\|"false"` | Return HTML response (used by the frontend), otherwise JSON |
> 
> **JSON Response**
> 
> ```javascript
> {
>   "url_full": string
>   "url": string
>   "base_url": string
>   "target": string
> }
> ```
> 
> The `url_full` attribute is the full short-URL, equivalent to `{base_url}/{url}`.
> 
> The `url` attribute is the resulting URL slug.
> 
> The `base_url` attribute is the protocol and domain part of the short-URL.
> 
> The `target` attribute is the destination URL, to be used for redirecting.
