---
title: "Understanding VLANs"
date: 2026-10-11
draft: false
tags: ["networking", "vlan", "switching"]
categories: ["Guides"]
summary: "A short, practical intro to VLANs and how to configure them on a managed switch."
cover:
  image: "images/vlans.svg"
  alt: "Two VLANs sharing one switch"
  caption: "Two logical networks (VLAN 10 and VLAN 20) on a single physical switch"
---

This post was generated with `./scripts/new-post.sh "Understanding VLANs"`. Notice the cover image above and the diagram below both live in this post's `images/` folder.

A **VLAN** (Virtual LAN) lets one physical switch act as several separate networks. Devices in different VLANs can't talk to each other unless a router connects them — which is exactly what you want for separating Engineering from Guest traffic.

{{< figure src="images/vlans.svg" alt="VLAN segmentation" caption="VLAN 10 (Engineering) and VLAN 20 (Guest) isolated on one switch" >}}

## Creating the VLANs

On a typical managed switch you create the VLANs first:

```bash
# Cisco-style CLI
configure terminal
vlan 10
 name Engineering
vlan 20
 name Guest
exit
```

## Assigning access ports

Each access port belongs to exactly one VLAN:

```bash
interface GigabitEthernet0/1
 switchport mode access
 switchport access vlan 10
exit

interface GigabitEthernet0/2
 switchport mode access
 switchport access vlan 20
```

## Trunking to the router

A **trunk** carries multiple VLANs between switches or to a router:

```bash
interface GigabitEthernet0/24
 switchport mode trunk
 switchport trunk allowed vlan 10,20
```

## Verifying

```bash
show vlan brief
show interfaces trunk
```

| VLAN | Name        | Subnet        | Purpose        |
| ---- | ----------- | ------------- | -------------- |
| 10   | Engineering | 10.0.10.0/24  | Staff devices  |
| 20   | Guest       | 10.0.20.0/24  | Visitors       |

## Wrap up

That's the workflow: **run the script → add images to `images/` → write → `hugo server -D` → `git push`**.
