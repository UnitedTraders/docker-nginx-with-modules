#!/bin/bash -e

assert() {
  local expected="$1"
  local actual="$2"
  local message="$3"

  if [[ "$expected" == "$actual" ]]; then
    echo "✅ SUCESS: $message"
  else
    echo "❌ FAIL: $message"
    echo "   ➡ Expected: '$expected', Obtained: '$actual'"
    exit 1
  fi
}

test_nginx_serving_request() {
    response=$(curl --fail --silent --show-error http://localhost:8080/)
    assert "nginx config check ok" "$response" "/ with expected response"
}

test_vts_status() {
    status_code=$(curl --silent --show-error -o /dev/null -w '%{http_code}' http://localhost:8080/status)
    assert "200" "$status_code" "/status vts endpoint returns 200"
}

echo "Running tests"

test_nginx_serving_request
test_vts_status

echo "✅ SUCESS: All tests passed"
