#!/usr/bin/env sh

set -e
set -u

setup_gpio() {
        echo "Setting up $1 as $2"
        if [ -d /sys/class/gpio/gpio${1} ]; then
                echo ${1} > /sys/class/gpio/unexport
                sleep 0.1
        fi
        echo ${1} > /sys/class/gpio/export
        sleep 0.1
        if [ $2 -eq 0 ]; then
                echo 'out' > /sys/class/gpio/gpio${1}/direction
                sleep 0.1
                echo 0 > /sys/class/gpio/gpio${1}/value
        else
                echo 'in' > /sys/class/gpio/gpio${1}/direction
        fi
}

setup_pwm() {
        echo "Setting up pwm$1 "
        if [ -d /sys/class/pwm/pwmchip0/pwm${1} ]; then
                echo ${1} > /sys/class/pwm/pwmchip0/unexport
                sleep 0.1
        fi
        echo ${1} > /sys/class/pwm/pwmchip0/export
        sleep 0.1
}

## Status LEDs
setup_gpio 23 0
setup_gpio 24 0

## Motor Drivers' inputs (interrupts)
# Flag
setup_gpio 17 1
# ~Standby
setup_gpio 22 0
# Busy
setup_gpio 27 1

## ToF XSHUT pins
setup_gpio 6 0
setup_gpio 16 0
setup_gpio 19 0
setup_gpio 20 0
setup_gpio 21 1
setup_gpio 26 0

## Misc
# SPI CS0&1 - disabled, configured via overlay
#setup_gpio 7 0
#setup_gpio 8 0
# SPI IRQext
setup_gpio 25 1

## PWM
# Fan pwm0 and lidar servo pwm1
setup_pwm 0
setup_pwm 1


