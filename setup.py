from setuptools import setup

setup(
    name='mqtt2graphite',
    description="This program subscribes to any number of MQTT topics, extracts a value from the messages' payload and sends that off to Graphite via Carbon over a UDP socket.",

    py_modules=['mqtt2graphite'],
    install_requires=[
        'paho-mqtt',
        'supervisor',
        ],
    entry_points={
        'console_scripts': [
            "mqtt2graphite = mqtt2graphite:main",
        ]
    },
)

