import { HTTP_NO_CONTENT } from 'constants'

const handleFetchResponse = function(response) {
  // Fetch does not throw HTTP errors as javascript errors.
  // Check for an error and throw if it exists.
  if (!response.ok) {
    const contentType = response.headers.get(`content-type`)
    if (contentType && contentType.includes(`application/json`)) {
      // If the API error returned JSON describing the error,
      // attempt to parse it
      return response.json().then(result => {
        throw Error(result.error)
      }, error => {
        // The response had a JSON content-type header but
        // did not return valid JSON
        throw Error(error)
      })
    } else {
      // The response did not return JSON
      throw Error(response.statusText)
    }
  } else if (response.status === HTTP_NO_CONTENT) {
    // Don't attempt to extract JSON when the HTTP status
    // indicates that no body is present.
    return Promise.resolve()
  } else {
    // Extract the successful response.
    return response.json()
  }
};

const fetchRequest = function(url, method, body) {
  const csrfToken = document.querySelector(`meta[name="csrf-token"]`).getAttribute(`content`)

  const headers = new Headers({
    'Accept': `application/json`,
    'Content-Type': `application/json`,
    'X-CSRF-TOKEN': csrfToken
  })

  return fetch(url, {
    method: method,
    body: JSON.stringify(body),
    headers: headers,
    credentials: `include`
  }).then(response => handleFetchResponse(response))

}

const getRequest = function(url) {
  return fetchRequest(url, `GET`)
}

const postRequest = function(url, body) {
  return fetchRequest(url, `POST`, body)
}

const patchRequest = function(url, body) {
  return fetchRequest(url, `PATCH`, body)
}

const deleteRequest = function(url) {
  return fetchRequest(url, `DELETE`)
}

export {
  getRequest,
  postRequest,
  patchRequest,
  deleteRequest
}
