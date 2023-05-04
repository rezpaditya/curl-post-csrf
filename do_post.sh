#!/bin/bash

# Use set -x at the begining and set +x at the end of the file
# to debug the operation on Bash

function executeCurlPost() {
    url=${1}
    dataParam=${2}

    cookie="cookie.txt"
    tmpOutput=$( curl -ks -c ${cookie} -b ${cookie} ${url})
    csrfToken=$( echo "${tmpOutput}" | grep csrf | sed -e 's/.*value="//g' -e 's/">//g')
    payload="${dataParam}&csrf_token=${csrfToken}"

    echo "--------------------------------------------------------------------------------------------------------"
    echo "-> URL            :" ${url}
    echo "-> INPUT Cookie   :" ${cookie}
    echo "-> CSRF Token     :" ${csrfToken}
    echo "-> Data           :" ${payload}
    echo "--------------------------------------------------------------------------------------------------------"

    args=("-k" "-v" "${url}" --cookie "${cookie}" --cookie-jar ${cookie} --data ${payload})

    echo "---------------------------------- cURL command to be executed -----------------------------------------"
    echo curl "${args[@]}"
    echo "--------------------------------------------------------------------------------------------------------"

    # Execute the cURL post and store the response
    output=$( curl "${args[@]}" 2>&1 )
    echo ${output}

    # Check the response to check whether it success or fail...
}

baseUrl="http://localhost:5000"
secretData="vault_secret=123&vault_secret_confirm=123"

executeCurlPost "${baseUrl}/secret-vault/" ${secretData}
