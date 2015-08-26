/*
 * Intel ACPI Component Architecture
 * AML/ASL+ Disassembler version 20141107-64 [Jan  2 2015]
 * Copyright (c) 2000 - 2014 Intel Corporation
 * 
 * Disassembling to non-symbolic legacy ASL operators
 *
 * Disassembly of SSDT-0.aml, Tue Aug 25 22:52:52 2015
 *
 * Original Table Header:
 *     Signature        "SSDT"
 *     Length           0x00000228 (552)
 *     Revision         0x01
 *     Checksum         0xAF
 *     OEM ID           "INTEL"
 *     OEM Table ID     "sensrhub"
 *     OEM Revision     0x00000000 (0)
 *     Compiler ID      "INTL"
 *     Compiler Version 0x20120711 (538052369)
 */
DefinitionBlock ("SSDT-0.aml", "SSDT", 1, "INTEL", "sensrhub", 0x00000000)
{

    External (_SB_.PCI0.I2C0.DFUD, UnknownObj)
    External (_SB_.PCI0.I2C0.SHUB, UnknownObj)
    External (_SB_.RDGP, MethodObj)    // 1 Arguments
    External (_SB_.WTGP, MethodObj)    // 2 Arguments
    External (SDS0, FieldUnitObj)
    External (USBH, FieldUnitObj)

    Scope (\)
    {
        Device (SHAD)
        {
            Name (_HID, EisaId ("INT33D0"))  // _HID: Hardware ID
            Name (_CID, EisaId ("PNP0C02"))  // _CID: Compatible ID
            Method (_STA, 0, Serialized)  // _STA: Status
            {
                If (LOr (And (SDS0, One), And (USBH, One)))
                {
                    Return (0x0F)
                }

                Return (Zero)
            }

            
        }
    }
}

