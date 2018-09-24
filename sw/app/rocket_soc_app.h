/*
 * rocket_soc_app.h
 *
 *  Created on: Sep 20, 2018
 *      Author: ballance
 */

#ifndef INCLUDED_ROCKET_SOC_APP_H
#define INCLUDED_ROCKET_SOC_APP_H

#ifdef __cplusplus
extern "C" {
#endif

void rocket_soc_app_init(void);

void rocket_soc_app_pre_main(void);

void rocket_soc_app_post_main(void);


#ifdef __cplusplus
}
#endif


#endif /* INCLUDED_ROCKET_SOC_APP_H */

