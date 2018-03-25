import fetch from 'isomorphic-fetch';

port = (process.env.OPENSHIFT_NODEJS_PORT || process.env.PORT || '3000')
ip = (process.env.OPENSHIFT_NODEJS_IP || '127.0.0.1')
export API_URL = (if (typeof window == 'undefined') then ('http://' + ip + ':' + port) else '') + '/api/'

export callApiWithBody = (endpoint, method, headers, body) ->
    _debug_marker = {qwe: '13_13_13_13_13_13_13_13_13_13_13_13_13_13_13_13_13_13_13_13_13_13_13_13_13_13_13_13_13_13_13_13_13_13_13_13_13_13_13_13_13_13_13_13_13_13_13_13_13_13_13_13_13_13_13_13_13_13_13_13_13_13_13_13_13_13_13_13_13_13_13_13_13_13_13_13_13_13_13_13_13_13_13_13_13_13_13_13_13_13_13_13_13_13_13_13_13_13_13_13'}
    response = await fetch(API_URL + endpoint, {
        credentials: 'same-origin',
        method: method,
        headers,
        body
    })
    try
        _debug_marker = {qwe: '14_14_14_14_14_14_14_14_14_14_14_14_14_14_14_14_14_14_14_14_14_14_14_14_14_14_14_14_14_14_14_14_14_14_14_14_14_14_14_14_14_14_14_14_14_14_14_14_14_14_14_14_14_14_14_14_14_14_14_14_14_14_14_14_14_14_14_14_14_14_14_14_14_14_14_14_14_14_14_14_14_14_14_14_14_14_14_14_14_14_14_14_14_14_14_14_14_14_14_14'}
        return await response.json()
    catch
        return {}


export default callApi = (endpoint, data) ->
    method = if data then 'POST' else 'GET'
    headers = {
        'Content-Type': 'application/json'
    }
    body = JSON.stringify(data)
    return callApiWithBody(endpoint, method, headers, body)
