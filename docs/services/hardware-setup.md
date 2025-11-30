# Hardware Setup for Bitstreaming

Advanced hardware configuration for lossless audio/video passthrough and optimal media
playback.

## Overview

For optimal quality with high-end audio/video formats, a dedicated client setup eliminates
transcoding issues common with TV-integrated clients.

!!! note "Hardware Optimization"
    This setup prioritizes direct play over compatibility, ensuring lossless transmission of
    advanced formats like Dolby Vision 7 and Dolby Atmos through the entire chain.

## Hardware Components

### Client Device

**[Homatics Box R 4K Plus](https://www.homatics.com/products/box-r-4k-plus)** running **[CoreElec](https://coreelec.org/)**

#### Capabilities

- Hardware-accelerated decoding
- HDMI passthrough
- Dolby Vision 7.6 (with FEL)
- HDR10/HDR10+
- Dolby Atmos
- DTS:X
- Lossless audio codecs

**Reference:** [Device Codec Compatibility](https://docs.google.com/spreadsheets/u/0/d/15i0a84uiBtWiHZ5CXZZ7wygLFXwYOd84/htmlview#gid=845372636)

### Advantages over WebOS

- Avoids transcoding limitations
- No AAC audio conversion
- No HDR fallbacks from Dolby Vision 7
- Direct bitstreaming support

### Connection Chain

```text
Router → LAN → Homatics Box → HDMI → Samsung HW-Q995D Soundbar → HDMI eARC → LG G4 TV
```

#### Compatibility

- Full Dolby Vision 7.6 (with FEL) support
- Dolby TrueHD Atmos lossless audio passthrough
- Reference: [Test Results](https://discourse.coreelec.org/t/ce-ng-dolby-vision-fel-for-dv-licensed-socs-s905x2-s922x-z-s905x4/50953)

### Key Advantages

- Eliminates audio transcoding to AAC
- Prevents video fallbacks to standard HDR
- Reduces latency and server load
- Future-proof for 8K/120Hz with HDMI 2.1

## Installation Instructions

### Initial Installation

#### Step 1: Prepare USB Drive

1. Download [CoreELEC 21.3](https://github.com/CoreELEC/CoreELEC/releases/download/21.3-Omega/CoreELEC-Amlogic-ng.arm-21.3-Omega-Generic.img.gz)
2. Flash to USB drive using [Balena Etcher](https://etcher.balena.io/)

#### Step 2: Configure Device Tree

1. Browse to Device Trees folder on USB drive
2. Copy `sc2_s905x4_sei_smb_280.dtb` to root folder (same level as `kernel.img`)
3. Rename to `dtb.img` (ignore warnings)

#### Step 3: Add Dolby Vision Support

1. Download [dovi.ko](https://drive.google.com/file/d/1985DIi9Bh6ZIm2IXCpCuhCvQQk9xCNCQ/view?usp=drive_link)
2. Copy to same location as `dtb.img`

#### Step 4: Boot CoreELEC

1. Insert USB drive into Homatics Box
2. Insert power adapter
3. Device should boot to CoreELEC

!!! tip "Boot Troubleshooting"
    If device doesn't boot from USB:
    - Restart from Android TV GUI until USB is recognized
    - Try reset button technique from [official documentation](https://wiki.coreelec.org/coreelec:ceboot)
    - Reboot from Android recovery menu

#### Step 5: Complete Setup

1. Follow initial setup wizard
2. Enable SSH (recommended for debugging)

## Kodi Configuration

### Cache Settings

#### Settings → Services → [Caching](https://kodi.wiki/view/Settings/Services/Caching)

Enable expert settings and configure:

| Setting | Value | Purpose |
| ------- | ----- | ------- |
| Buffer mode | All network filesystems | Optimizes network streaming |
| Memory Size | 512MB | Sufficient buffer for 4K Remuxes |
| Read Factor | 10.00x | Reduces buffering during playback |

### Audio Settings

#### Settings → Services → Audio

Configure for lossless ATMOS passthrough:

| Setting | Value |
| ------- | ----- |
| Audio Output Device | ALSA:AML-AUGESOUND, HDMI Multi Ch PCM |
| Number of Channels | 7.1 |
| Output Configuration | Best Match |
| Keep Audio Device Alive | Always |
| Enable Audio Passthrough | Enabled |
| Passthrough Output Device | ALSA:AML-AUGESOUND, HDMI |
| Enable all audio codecs | AC3, E-AC3, DTS, TrueHD, DTS-HD |

!!! info "Audio Device Persistence"
    "Keep Audio Device Alive" prevents audio device reinitialization between tracks.

### Display Settings

#### Settings → Services → Display

Enable expert settings and configure:

| Setting | Value | Purpose |
| ------------------------- | ------ | ---------------------------- |
| Disable Noise Reduction | Enabled | Preserves original video quality |
| Dolby Vision LED Mode | TV-Led | Optimizes DV tone mapping |

### Debug Logging (Optional)

#### Settings → Services → Logging

| Setting              | Value                        | Note                                             |
|----------------------|------------------------------|--------------------------------------------------|
| Enable Debug logging | For troubleshooting only     | Disable after resolving issues (consumes CPU)    |

## System Configuration

### Network Settings

#### Settings → CoreELEC → Network

- **Turn off wireless connection**
- Use wired Ethernet for stable streaming of high-bitrate content

### Update Settings

#### Settings → CoreELEC → Updates

- **Turn off all auto-update settings**
- Prevents automatic updates that may cause instability

## Jellyfin Integration

### Install Jellyfin Add-on

1. Install [Jellyfin for Kodi](https://jellyfin.org/docs/general/clients/kodi/#embedded-devices-android-tv-firestick-and-other-tv-boxes)
2. Navigate GUI to add all libraries
3. Shutdown device
4. Connect to Dolby Vision display or soundbar with passthrough
5. Ensure wired LAN connection

## Playback Verification

### Testing Dolby Vision

#### Expected Behavior

- Dolby Vision 7.6 with FEL content should play correctly
- May experience a few frame drops initially while TV switches modes

#### Workaround for Initial Drops

1. Rewind movie to beginning
2. Playback should be perfect after display has switched to desired mode

### Verification Checklist

- [ ] Dolby Vision badge appears during playback
- [ ] Audio outputs as Dolby Atmos or DTS:X (not AAC)
- [ ] No transcoding on server
- [ ] Smooth playback without buffering
- [ ] HDR/DV metadata displays correctly

## Troubleshooting

### No Audio

- Check passthrough settings
- Verify soundbar HDMI connection
- Ensure eARC is enabled
- Check audio codec support

### Video Not Playing

- Verify video codec support
- Check network bandwidth
- Review Jellyfin server logs
- Test with different content

### Frame Drops

- Check network stability
- Increase buffer size
- Verify media source quality
- Monitor CPU usage

### Dolby Vision Issues

- Verify dovi.ko is loaded
- Check TV DV support
- Review display settings
- Test with known DV content

## Performance Optimization

### Network

- Use Gigabit Ethernet
- Quality Cat6 or better cables
- Minimize network hops
- QoS for streaming traffic

### Storage

- Fast storage on Jellyfin server
- Sufficient bandwidth for 4K remux
- Regular maintenance

### Playback

- Close background apps
- Keep CoreELEC updated
- Monitor device temperature
- Clean cache periodically

## Related Documentation

- [Media Services](media-services.md) - Server-side configuration
- [Architecture](../architecture/index.md) - System architecture
