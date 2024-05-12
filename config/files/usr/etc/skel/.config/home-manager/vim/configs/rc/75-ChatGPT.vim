lua << EOF
require('chatgpt').setup {
    api_key_cmd = "cat /run/secrets/openai/api-key",
    openai_params = {
        model = "gpt-4",
    },
}
EOF
