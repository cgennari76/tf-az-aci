locals {
  appname              = "${azurerm_container_group.aci-helloworld.name}"
  location             = "${azurerm_resource_group.rg.location}"
  rg                   = "${azurerm_resource_group.rg.name}"
}

resource "azurerm_network_profile" "container" {
  name                = "container"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  container_network_interface {
    name = "containerNIC"

    ip_configuration {
      name      = "containerconfig"
      subnet_id = azurerm_subnet.gateway.id
    }
  }
}

resource "azurerm_container_group" "ssl-frontend" {
  name                = "ssl-frontend"
  location            = local.location
  resource_group_name = local.rg
  ip_address_type     = "Private"
  os_type             = "Linux"

  container {
    name   = "nginx-with-ssl"
    image  = "index.docker.io/ubuntu/nginx"
    cpu    = "1.0"
    memory = "1.5"
    ports {
      port = 443
      protocol = "TCP"
    }
    volume {
    name       = "nginx-config"
    mount_path = "/etc/nginx"
    secret = {
      "ssl.crt"=<<EOT
	LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSURFVENDQWZrQ0ZITFZQdTcvMmVTVFBNTmds
        Y1hMT2E2YUtiem9NQTBHQ1NxR1NJYjNEUUVCQ3dVQU1FVXgKQ3pBSkJnTlZCQVlUQWtGVk1STXdF
        UVlEVlFRSURBcFRiMjFsTFZOMFlYUmxNU0V3SHdZRFZRUUtEQmhKYm5SbApjbTVsZENCWGFXUm5h
        WFJ6SUZCMGVTQk1kR1F3SGhjTk1qSXdPREEyTVRrME1ESTNXaGNOTWpNd09EQTJNVGswCk1ESTNX
        akJGTVFzd0NRWURWUVFHRXdKQlZURVRNQkVHQTFVRUNBd0tVMjl0WlMxVGRHRjBaVEVoTUI4R0Ex
        VUUKQ2d3WVNXNTBaWEp1WlhRZ1YybGtaMmwwY3lCUWRIa2dUSFJrTUlJQklqQU5CZ2txaGtpRzl3
        MEJBUUVGQUFPQwpBUThBTUlJQkNnS0NBUUVBdnJNRHRqWmJLSE5UdUM1QmpPRjB1T1d1MFJUM3hj
        UjlhQk1Na0R4alJ2MlpRY3FSClM3Y1Q1b1gyNUVrbUhWcVlhMEJFOEF6b0IwTmZnZldoWG1JdzJr
        S3VyZjB2TkpLM2oxeWlZSnFpclFsNFlac3oKallsQTEzR3ViQnFMMlhidWNPMUNtOC8wVXUzV2ta
        b0ZaQ0s0bkQ0bGxGOEpGcTlnakRJTndoU0w5aVZuQ200Rwp4MXpObDE0SzZzaXVIQ1dqVjRjL2tH
        ZXdvWHAvN0I0bVdSd2pWd2tHTU1Ea0VWU0ZnWGxlV1UrTTdsaGRtN0ZKCnYvUnBSaGlOeVJRRDZo
        UzNFajVDUmlFWU9KYzBrbjQ4d2M4Q1dMT2NpelJiU0pXQm5MYVVJNEd1V01pRzNEbk0KYXp4SkR1
        c1VlWkk4aTJhOW9iQ09lOThBVEd4M1NDYjc4c1ZWRXdJREFRQUJNQTBHQ1NxR1NJYjNEUUVCQ3dV
        QQpBNElCQVFBRm5qVDVsdnRVZ0I2V2N2QmpXSTFMZ0kvTHJYMk9wNklEQzh3V0orQXl5RXI5UWlI
        cEQxTFN2Qm54ClJPWTViTkNYSXVJSHNJNUFWc2ZkVkJiRXBZZ25hZGsvUzNNK2huelNJYWFjSkxy
        cDBsS0JOTmJlSTdna0RPcmwKYVZJeldWL0tIRldVMHBPcUJMNGUrbUswOUxZWVBHQm5NK3ovcUpT
        MXV0NHdtV3ZlVUZxM3ZpMkpFY1ZkNkZKNwpjZFR2VDBXUTZ2ekNVWkhyMUtDbW5JM1R2dDJLVWo3
        NGhGMlgrbFNlU2dWSEJSRmxtNm52WFR5TGlqalRZVkIzCmpwd0gvNHBvUFNLS0ZEczM3RUNJam1p
        TmhHNU5YUm1mN3NTSUp1TDJycytuUHZEbC9za1VOZ0tVNVJNZ0c2WDUKd2d4K0hmKzdUaEZ2VUtP
        Mnh1Ukpvb2Q0aGFLcQotLS0tLUVORCBDRVJUSUZJQ0FURS0tLS0tCg==
        EOT
      "ssl.key"=<<EOT
	LS0tLS1CRUdJTiBQUklWQVRFIEtFWS0tLS0tCk1JSUV2UUlCQURBTkJna3Foa2lHOXcwQkFRRUZB
        QVNDQktjd2dnU2pBZ0VBQW9JQkFRQytzd08yTmxzb2MxTzQKTGtHTTRYUzQ1YTdSRlBmRnhIMW9F
        d3lRUEdORy9abEJ5cEZMdHhQbWhmYmtTU1lkV3BoclFFVHdET2dIUTErQgo5YUZlWWpEYVFxNnQv
        Uzgwa3JlUFhLSmdtcUt0Q1hoaG16T05pVURYY2E1c0dvdlpkdTV3N1VLYnovUlM3ZGFSCm1nVmtJ
        cmljUGlXVVh3a1dyMkNNTWczQ0ZJdjJKV2NLYmdiSFhNMlhYZ3JxeUs0Y0phTlhoeitRWjdDaGVu
        L3MKSGlaWkhDTlhDUVl3d09RUlZJV0JlVjVaVDR6dVdGMmJzVW0vOUdsR0dJM0pGQVBxRkxjU1Br
        SkdJUmc0bHpTUwpmanpCendKWXM1eUxORnRJbFlHY3RwUWpnYTVZeUliY09jeHJQRWtPNnhSNWtq
        eUxacjJoc0k1NzN3Qk1iSGRJCkp2dnl4VlVUQWdNQkFBRUNnZ0VBTlo4b29BZlF3aU1MbTNLR1JC
        THhPeng2VjVoSnczWm92T2IrVldCbG1nU2QKSDM3U05EUWFpR3VLN000VXhaUS8zNGlHMmVrSEpX
        T3dhMTZpTFdQMjBLaUhiYTBQcFB6TVdLZDNrU3BxSzdYSgovOGdnU3VBWk4zdGp6RW42b1A5c05K
        ekNhZ1dqY2Q0bXczSkhxY3lKbElWMUU2OVZZdWVWZ2xaZ3YvMy9EUXNqCkdDOU80K1BCQnAwK2pi
        R2Iwd015MXRCeGdZa2FGeWJubnJZdXpOZTFid2hqLzFCb0lFZWZKSUhvWDJnSi9xTDEKVGs1Mkp6
        R295ak1jOTUvRHk1RlVRbk92ZDdCc0lqMzhCK3dlTDFUVk1RZXZnTTBNc1k3ZC9iUWtyNlBsQ1Av
        OApyWTM3UytjUnBNLzNtWTRrL2toN3JyU3hvQTY4UEVRbmw3aHNtWTg2b1FLQmdRRGRhY2dFZWd6
        aVZSdkxDNHJDCmRWbFY2cnVPbEQ0SllqTEpBRFNPenRWcGJueVFBTVZwblhsSktBNE9MNG1ZZ3Jq
        aUVLRnZOSlpOODNCay9XTkwKekw4Vm5sQ0QzdnFYdWp2OGNrZGl1N1BaSVU4Zyt6MHZCVDlwODdH
        Mzd4QXdzYmU1dTUyRTJsMnpERTNMcEs5NwpXRG9iTlhYZUtTSHNwQW9VbFNyK2E3SnpSUUtCZ1FE
        Y2ZQOEtpWUxBS1RqSmFxaWxFbkl6blJnSmE5RkFIRFFCClRkcG1wM2hSQTZQc3Q1NEZlU09KaCtv
        cGFnOHNaVGd1NWR6V0UzU09aOFlmTXpQZDZPc3FYOTZhU3V4dnJOWkYKR2lmRGVKYktxNFJDaXhG
        aFN6dW1CRHM2U0tsd0l5SklJZlowTjFFelV1TWdsRmozbURzNHNGbVVhdllIanRGYgpKTWxkSWNi
        QWR3S0JnUUM5emZHbVRNNkFzNzc0cDdOVEVlLzhaQlpXbXFRM3ZST1dGWFA0dkR4Y2ZsZVB4dWww
        CnFZY1FmS0xYN0U2RERBVGIzcS9WT2ZwalpuNENST2w3VUZDNmdwVzVCa3hDQjJkbStMeFRXbDlK
        a25GWDc2ZzYKaDhBZDNzZUp5d2xSQlBoZjR3S2NvZWxURlFnWHU5eW0yeklzb3Y2ZzdSZmsyWmEr
        b0VWVUJ4VGFGUUtCZ0grTQpiNTJRM3VwNjdqYldWS2pwZXRjUTBZN2hxRE1HSGErRGNneGdaT0c0
        MFdObTlTc0ZZT0YybHFkT2kyaUxSVzBiCjNCeWJOSm9NdmpmZVR1cllpdklBYzYyZUdoaWdTM08r
        SmJLV1YrVDJRNVNiRG5yU0lyZHZTelAwUk5CeUFxcm4KdXNLUUhaRXJLZWoyNkdDUzErOTdWTmJl
        NldTRjRlWnY2V3pPMVVNUkFvR0FScWJNWktFWTZiaEFjQWdUbi9SawoyRmZ4Z2VKeVpLbmFheENV
        TXFLTTZpNE5TSVFCR1hUK2NXV1oxclV0bjJ1Njg4SGUzenFxZzd1ZHMrMWFzM3o2ClFwaURoKzhS
        NFNjTzFWSW9oSlM1L3hvN0VXMVQ1Q25yUytaRDUrS2VybUFxaEVicXpBRXF2RUxDMjFTTVk0bnYK
        ekN1Rzd2bG9qcnArMldMR0xmbTUyL2M9Ci0tLS0tRU5EIFBSSVZBVEUgS0VZLS0tLS0K
        EOT
      "nginx.conf"=<<EOT
        IyBuZ2lueCBDb25maWd1cmF0aW9uIEZpbGUKIyBodHRwczovL3dpa2kubmdpbngub3JnL0NvbmZp
        Z3VyYXRpb24KCiMgUnVuIGFzIGEgbGVzcyBwcml2aWxlZ2VkIHVzZXIgZm9yIHNlY3VyaXR5IHJl
        YXNvbnMuCnVzZXIgbmdpbng7Cgp3b3JrZXJfcHJvY2Vzc2VzIGF1dG87CgpldmVudHMgewogIHdv
        cmtlcl9jb25uZWN0aW9ucyAxMDI0Owp9CgpwaWQgICAgICAgIC92YXIvcnVuL25naW54LnBpZDsK
        Cmh0dHAgewoKICAgICNSZWRpcmVjdCB0byBodHRwcywgdXNpbmcgMzA3IGluc3RlYWQgb2YgMzAx
        IHRvIHByZXNlcnZlIHBvc3QgZGF0YQoKICAgIHNlcnZlciB7CiAgICAgICAgbGlzdGVuIFs6Ol06
        NDQzIHNzbDsKICAgICAgICBsaXN0ZW4gNDQzIHNzbDsKCiAgICAgICAgc2VydmVyX25hbWUgbG9j
        YWxob3N0OwoKICAgICAgICAjIFByb3RlY3QgYWdhaW5zdCB0aGUgQkVBU1QgYXR0YWNrIGJ5IG5v
        dCB1c2luZyBTU0x2MyBhdCBhbGwuIElmIHlvdSBuZWVkIHRvIHN1cHBvcnQgb2xkZXIgYnJvd3Nl
        cnMgKElFNikgeW91IG1heSBuZWVkIHRvIGFkZAogICAgICAgICMgU1NMdjMgdG8gdGhlIGxpc3Qg
        b2YgcHJvdG9jb2xzIGJlbG93LgogICAgICAgIHNzbF9wcm90b2NvbHMgICAgICAgICAgICAgIFRM
        U3YxLjI7CgogICAgICAgICMgQ2lwaGVycyBzZXQgdG8gYmVzdCBhbGxvdyBwcm90ZWN0aW9uIGZy
        b20gQmVhc3QsIHdoaWxlIHByb3ZpZGluZyBmb3J3YXJkaW5nIHNlY3JlY3ksIGFzIGRlZmluZWQg
        YnkgTW96aWxsYSAtIGh0dHBzOi8vd2lraS5tb3ppbGxhLm9yZy9TZWN1cml0eS9TZXJ2ZXJfU2lk
        ZV9UTFMjTmdpbngKICAgICAgICBzc2xfY2lwaGVycyAgICAgICAgICAgICAgICBFQ0RIRS1SU0Et
        QUVTMTI4LUdDTS1TSEEyNTY6RUNESEUtRUNEU0EtQUVTMTI4LUdDTS1TSEEyNTY6RUNESEUtUlNB
        LUFFUzI1Ni1HQ00tU0hBMzg0OkVDREhFLUVDRFNBLUFFUzI1Ni1HQ00tU0hBMzg0OkRIRS1SU0Et
        QUVTMTI4LUdDTS1TSEEyNTY6REhFLURTUy1BRVMxMjgtR0NNLVNIQTI1NjprRURIK0FFU0dDTTpF
        Q0RIRS1SU0EtQUVTMTI4LVNIQTI1NjpFQ0RIRS1FQ0RTQS1BRVMxMjgtU0hBMjU2OkVDREhFLVJT
        QS1BRVMxMjgtU0hBOkVDREhFLUVDRFNBLUFFUzEyOC1TSEE6RUNESEUtUlNBLUFFUzI1Ni1TSEEz
        ODQ6RUNESEUtRUNEU0EtQUVTMjU2LVNIQTM4NDpFQ0RIRS1SU0EtQUVTMjU2LVNIQTpFQ0RIRS1F
        Q0RTQS1BRVMyNTYtU0hBOkRIRS1SU0EtQUVTMTI4LVNIQTI1NjpESEUtUlNBLUFFUzEyOC1TSEE6
        REhFLURTUy1BRVMxMjgtU0hBMjU2OkRIRS1SU0EtQUVTMjU2LVNIQTI1NjpESEUtRFNTLUFFUzI1
        Ni1TSEE6REhFLVJTQS1BRVMyNTYtU0hBOkFFUzEyOC1HQ00tU0hBMjU2OkFFUzI1Ni1HQ00tU0hB
        Mzg0OkVDREhFLVJTQS1SQzQtU0hBOkVDREhFLUVDRFNBLVJDNC1TSEE6QUVTMTI4OkFFUzI1NjpS
        QzQtU0hBOkhJR0g6IWFOVUxMOiFlTlVMTDohRVhQT1JUOiFERVM6ITNERVM6IU1ENTohUFNLOwog
        ICAgICAgIHNzbF9wcmVmZXJfc2VydmVyX2NpcGhlcnMgIG9uOwoKICAgICAgICAjIE9wdGltaXpl
        IFRMUy9TU0wgYnkgY2FjaGluZyBzZXNzaW9uIHBhcmFtZXRlcnMgZm9yIDEwIG1pbnV0ZXMuIFRo
        aXMgY3V0cyBkb3duIG9uIHRoZSBudW1iZXIgb2YgZXhwZW5zaXZlIFRMUy9TU0wgaGFuZHNoYWtl
        cy4KICAgICAgICAjIFRoZSBoYW5kc2hha2UgaXMgdGhlIG1vc3QgQ1BVLWludGVuc2l2ZSBvcGVy
        YXRpb24sIGFuZCBieSBkZWZhdWx0IGl0IGlzIHJlLW5lZ290aWF0ZWQgb24gZXZlcnkgbmV3L3Bh
        cmFsbGVsIGNvbm5lY3Rpb24uCiAgICAgICAgIyBCeSBlbmFibGluZyBhIGNhY2hlIChvZiB0eXBl
        ICJzaGFyZWQgYmV0d2VlbiBhbGwgTmdpbnggd29ya2VycyIpLCB3ZSB0ZWxsIHRoZSBjbGllbnQg
        dG8gcmUtdXNlIHRoZSBhbHJlYWR5IG5lZ290aWF0ZWQgc3RhdGUuCiAgICAgICAgIyBGdXJ0aGVy
        IG9wdGltaXphdGlvbiBjYW4gYmUgYWNoaWV2ZWQgYnkgcmFpc2luZyBrZWVwYWxpdmVfdGltZW91
        dCwgYnV0IHRoYXQgc2hvdWxkbid0IGJlIGRvbmUgdW5sZXNzIHlvdSBzZXJ2ZSBwcmltYXJpbHkg
        SFRUUFMuCiAgICAgICAgc3NsX3Nlc3Npb25fY2FjaGUgICAgc2hhcmVkOlNTTDoxMG07ICMgYSAx
        bWIgY2FjaGUgY2FuIGhvbGQgYWJvdXQgNDAwMCBzZXNzaW9ucywgc28gd2UgY2FuIGhvbGQgNDAw
        MDAgc2Vzc2lvbnMKICAgICAgICBzc2xfc2Vzc2lvbl90aW1lb3V0ICAyNGg7CgoKICAgICAgICAj
        IFVzZSBhIGhpZ2hlciBrZWVwYWxpdmUgdGltZW91dCB0byByZWR1Y2UgdGhlIG5lZWQgZm9yIHJl
        cGVhdGVkIGhhbmRzaGFrZXMKICAgICAgICBrZWVwYWxpdmVfdGltZW91dCAzMDA7ICMgdXAgZnJv
        bSA3NSBzZWNzIGRlZmF1bHQKCiAgICAgICAgIyByZW1lbWJlciB0aGUgY2VydGlmaWNhdGUgZm9y
        IGEgeWVhciBhbmQgYXV0b21hdGljYWxseSBjb25uZWN0IHRvIEhUVFBTCiAgICAgICAgYWRkX2hl
        YWRlciBTdHJpY3QtVHJhbnNwb3J0LVNlY3VyaXR5ICdtYXgtYWdlPTMxNTM2MDAwOyBpbmNsdWRl
        U3ViRG9tYWlucyc7CgogICAgICAgIHNzbF9jZXJ0aWZpY2F0ZSAgICAgIC9ldGMvbmdpbngvc3Ns
        LmNydDsKICAgICAgICBzc2xfY2VydGlmaWNhdGVfa2V5ICAvZXRjL25naW54L3NzbC5rZXk7Cgog
        ICAgICAgIGxvY2F0aW9uIC8gewogICAgICAgICAgICBwcm94eV9wYXNzIGh0dHA6Ly8xMC4wLjIu
        NDo4MDsgIyBUT0RPOiByZXBsYWNlIHBvcnQgaWYgYXBwIGxpc3RlbnMgb24gcG9ydCBvdGhlciB0
        aGFuIDgwCgogICAgICAgICAgICBwcm94eV9zZXRfaGVhZGVyIENvbm5lY3Rpb24gIiI7CiAgICAg
        ICAgICAgIHByb3h5X3NldF9oZWFkZXIgSG9zdCAkaG9zdDsKICAgICAgICAgICAgcHJveHlfc2V0
        X2hlYWRlciBYLVJlYWwtSVAgJHJlbW90ZV9hZGRyOwogICAgICAgICAgICBwcm94eV9zZXRfaGVh
        ZGVyIFgtRm9yd2FyZGVkLUZvciAkcmVtb3RlX2FkZHI7CiAgICAgICAgfQogICAgfQp9Cg==
        EOT
      }
    }
  }
  network_profile_id = azurerm_network_profile.container.id
}

resource "azurerm_network_profile" "backend" {
  name                = "backend"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  container_network_interface {
    name = "containerNIC"

    ip_configuration {
      name      = "containerconfig"
      subnet_id = azurerm_subnet.backend.id
    }
  }
}

resource "azurerm_container_group" "aci-helloworld" {
  name                = "aci-hw"
  location            = local.location
  resource_group_name = local.rg
  ip_address_type     = "Private"
  os_type             = "Linux"

  container {
    name   = "hw"
    image  = "index.docker.io/chrisgennari/dry-run-cloud:nodeubuntu"
    cpu    = "1.0"
    memory = "1.5"
    ports {
      port = 80
      protocol = "TCP"
    }
  }
  
  network_profile_id = azurerm_network_profile.backend.id

  image_registry_credential {
    username = "chrisgennari"
    password = "Solution5inc"
    server   = "index.docker.io"
  }
}
