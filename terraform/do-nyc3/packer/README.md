### Setup

Create a file called `variables.json`

```json
{
  "doco_token": "token"
}
```

### Building

packer build -var-file=variables.json template.json
