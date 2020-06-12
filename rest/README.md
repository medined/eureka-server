# Eureka REST API Usage

Eureka has a REST API that allows non-java technologies (like Python) to
interact with it.

This directory shows how to use `curl` to make the REST calls. Of course,
those calls can be replicated in any language.

Eureka doesn't care if a service is actually running. It only cares about
the information being sent to it. Therefore, this directory will use
FAKE_SERVICE as its service name.

Environment variables will be used to clarify where common information is
being used.

## Starting Eureka In Docker

```bash
docker run \
  --name eureka-server \
  --rm=true \
  --detach \
  --publish 8761:8761 \
  medined/eureka-server:2.3.0.RELEASE
```

## Links

* https://github.com/Netflix/eureka/wiki/Eureka-REST-operations
* https://dzone.com/articles/the-mystery-of-eureka-health-monitoring
* https://blog.asarkar.org/technical/netflix-eureka/

## Available Endpoints

* Register new application instance
* De-register application instance
* Send application instance heartbeat
* Query for all instances
* Query for all appID instances
* Query for a specific appID/instanceID
* Query for a specific instanceID
* Take instance out of service
* Move instance back into service (remove override)
* Update metadata
* Query for all instances under a particular vip address
* Query for all instances under a particular secure vip address

# Service Registration

The `service-register.sh` script can be used to register our FAKE_SERVICE. The
script is commented. Please read it before execution.

When registering a service, you can specify a status (UP, DOWN, STARTING,
OUT_OF_SERVICE, and UNKNOWN). If you specify, STARTING the service will not
be evicted if no heartbeat is received. Also, sending a heartbeat does not
change the status to UP.

`hostname` and `instance` can be thought of as synonmous as far as Eureka
is concerned.

# Service Information

You can request information about registered services using the following URL:

```bash
curl http://localhost:9000/eureka/apps
```

Then you can narrow down to a specific service:

```bash
curl http://localhost:9000/eureka/apps/FAKE-SERVICE
```

And finally, you can filter down to a specific instance or hostname. In the URL
below, `fake01` is the host name (AKA the instance).

```bash
curl http://localhost:9000/eureka/apps/FAKE-SERVICE/fake01
<instance>
  <hostName>fake01</hostName>
  <app>FAKE-SERVICE</app>
  <ipAddr>fake.com</ipAddr>
  <status>UP</status>
  <overriddenstatus>UNKNOWN</overriddenstatus>
  <port enabled="true">5000</port>
  <securePort enabled="false">443</securePort>
  <countryId>1</countryId>
  <dataCenterInfo class="com.netflix.appinfo.InstanceInfo$DefaultDataCenterInfo">
    <name>MyOwn</name>
  </dataCenterInfo>
  <leaseInfo>
    <renewalIntervalInSecs>30</renewalIntervalInSecs>
    <durationInSecs>90</durationInSecs>
    <registrationTimestamp>1591812947850</registrationTimestamp>
    <lastRenewalTimestamp>1591813378305</lastRenewalTimestamp>
    <evictionTimestamp>0</evictionTimestamp>
    <serviceUpTimestamp>1591812947341</serviceUpTimestamp>
  </leaseInfo>
  <metadata>
    <owner>George Harris</owner>
    <cost-code>1D234R</cost-code>
  </metadata>
  <homePageUrl>http://fake.com:5000/home</homePageUrl>
  <statusPageUrl>http://fake.com:5000/health</statusPageUrl>
  <healthCheckUrl>http://fake.com:5000/health</healthCheckUrl>
  <isCoordinatingDiscoveryServer>false</isCoordinatingDiscoveryServer>
  <lastUpdatedTimestamp>1591812947850</lastUpdatedTimestamp>
  <lastDirtyTimestamp>1591812947341</lastDirtyTimestamp>
  <actionType>ADDED</actionType>
</instance>
```

# Service Heartbeat

NOTE: Sending a heartbeat simply means that a service is not evicted. It
does not change a service's status.

The `service-heartbeat.sh` script can be used to send a heartbeat for our
fake service. It's function is quite simpe. It PUTs a request to the
following URL.

```
http://localhost:9000/eureka/apps/FAKE-SERVICE/fake01
```

Notice that no parameters are needed. This contradicts the examples on the
web but not the official documentation. I've seen examples showing that
`status` or `lastDirtyTimestamp` should be specified. They don't.

Heartbeat messages should be sent every 30 seconds.

When a service is evicted, you might see a message like the following in the
logs.

```
Evicting 1 items (expired=1, evictionLimit=1)
DS: Registry: expired lease for FAKE-SERVICE/fake01
```

# Service Deregistration

Deregistering a service is quite simple. Make a request like the following:

```bash
curl -X DELETE http://localhost:9000/eureka/apps/FAKE-SERVICE/fake01
```

# Query for a specific instanceID

Although we're not using Instance IDs, the URL will look like this:

```bash
curl http://localhost:9000/eureka/instances/fake01
```

# Service Status Change (overriddenstatus)

Using a curl command like that below, you can change the status of a service.
As far as I know, there is no security mechanism stopping a malicious actor
from arbitrarily changing status on a production system. Therefore, network
controls (like security groups) must be used to secure access.

```bash
curl -X PUT http://localhost:9000/eureka/apps/FAKE-SERVICE/fake01/status?value=DOWN
```

The REST request above sets the `overriddenstatus` field of a service. This
status must be cleared using this kind of request. Make sure to provide the
optional status. Otherwise, the status becomes UNKNOWN and the service will
be shortly evicted.

```bash
curl -X DELETE http://localhost:9000/eureka/apps/FAKE-SERVICE/fake01/status?value=UP
```

# Service Metadata Update

The request below will add or change metadata associated with a service. There
is no security stopping a bad actor from changing the wrong key, value or even
changing the wrong service.

```bash
curl -X PUT http://localhost:9000/eureka/apps/FAKE-SERVICE/fake01/metadata?color=BLUE
```
