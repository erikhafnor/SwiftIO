/*
 * @Copyright (c) 2020, MADMACHINE LIMITED
 * @Author: Your Name
 * @SPDX-License-Identifier: MIT
 */

#ifndef _SWIFT_CAN_H_
#define _SWIFT_CAN_H_

#include <stdint.h>
#include <sys/types.h>

/**
 * @brief Open a CAN interface
 *
 * @param id        CAN ID
 *
 * @return void*    CAN handle, NULL if not found or cannot be used.
 */
void *swifthal_can_open(int id);

/**
 * @brief Close a CAN interface
 *
 * @param can       CAN handle
 *
 * @retval 0 If successful.
 * @retval Negative errno code if failure.
 */
int swifthal_can_close(void *can);

/**
 * @brief Set CAN baud rate
 *
 * @param can       CAN handle
 * @param baudrate  CAN baud rate setting in bps
 *
 * @retval 0 If successful.
 * @retval Negative errno code if failure.
 */
int swifthal_can_baudrate_set(void *can, ssize_t baudrate);

/**
 * @brief Send a CAN message
 *
 * @param can       CAN handle
 * @param id        CAN message ID
 * @param data      Pointer to data buffer
 * @param length    Length of data buffer
 *
 * @retval 0 If successful.
 * @retval Negative errno code if failure.
 */
int swifthal_can_write(void *can, uint32_t id, const uint8_t *data, ssize_t length);

/**
 * @brief Receive a CAN message
 *
 * @param can       CAN handle
 * @param id        Pointer to store CAN message ID
 * @param data      Pointer to data buffer
 * @param length    Length of data buffer
 *
 * @retval Positive indicates the number of bytes actually read.
 * @retval Negative errno code if failure.
 */
int swifthal_can_read(void *can, uint32_t *id, uint8_t *data, ssize_t length);

#endif /* _SWIFT_CAN_H_ */
