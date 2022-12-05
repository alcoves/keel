# Handler function name must match the
# last part of <fileName>.<handlerName>
function handler () {

  # Get the data
  EVENT_DATA=$1

  # Log the event to stderr
  echo "$EVENT_DATA" 1>&2;

  # Respond to Lambda service by echoing the received data back
  RESPONSE="Echoing request: '$EVENT_DATA'"
  echo $RESPONSE
}