/*******************************************************************************
*
* E M B E D D E D   W I Z A R D   P R O J E C T
*
*                                                Copyright (c) TARA Systems GmbH
*                                    written by Paul Banach and Manfred Schweyer
*
********************************************************************************
*
* This file was generated automatically by Embedded Wizard. Please do not make 
* any modifications of this file! The modifications are lost when the file is
* generated again by Embedded Wizard!
*
* The template of this heading text can be found in the file 'head.ewt' in the
* directory 'Platforms' of your Embedded Wizard installation directory. If you
* wish to adapt this text, please copy the template file 'head.ewt' into your
* project directory and edit the copy only. Please avoid any modifications of
* the original template file!
*
* Version  : 8.20
* Profile  : STM32F429
* Platform : STM.STM32.RGB565
*
*******************************************************************************/

#ifndef _AnimatedListAnimatedList_H
#define _AnimatedListAnimatedList_H

#ifdef __cplusplus
  extern "C"
  {
#endif

#include "ewrte.h"
#if EW_RTE_VERSION != 0x00080014
  #error Wrong version of Embedded Wizard Runtime Environment.
#endif

#include "ewgfx.h"
#if EW_GFX_VERSION != 0x00080014
  #error Wrong version of Embedded Wizard Graphics Engine.
#endif

#include "_AnimatedListDayList.h"
#include "_AnimatedListTimeList.h"
#include "_CoreGroup.h"
#include "_CoreTimer.h"
#include "_ViewsRectangle.h"

/* Forward declaration of the class AnimatedList::AnimatedList */
#ifndef _AnimatedListAnimatedList_
  EW_DECLARE_CLASS( AnimatedListAnimatedList )
#define _AnimatedListAnimatedList_
#endif

/* Forward declaration of the class AnimatedList::DeviceClass */
#ifndef _AnimatedListDeviceClass_
  EW_DECLARE_CLASS( AnimatedListDeviceClass )
#define _AnimatedListDeviceClass_
#endif

/* Forward declaration of the class Core::KeyPressHandler */
#ifndef _CoreKeyPressHandler_
  EW_DECLARE_CLASS( CoreKeyPressHandler )
#define _CoreKeyPressHandler_
#endif

/* Forward declaration of the class Core::LayoutContext */
#ifndef _CoreLayoutContext_
  EW_DECLARE_CLASS( CoreLayoutContext )
#define _CoreLayoutContext_
#endif

/* Forward declaration of the class Core::View */
#ifndef _CoreView_
  EW_DECLARE_CLASS( CoreView )
#define _CoreView_
#endif

/* Forward declaration of the class Graphics::Canvas */
#ifndef _GraphicsCanvas_
  EW_DECLARE_CLASS( GraphicsCanvas )
#define _GraphicsCanvas_
#endif


/* This is the root component of the entire GUI application. */
EW_DEFINE_FIELDS( AnimatedListAnimatedList, CoreGroup )
  EW_OBJECT  ( Rectangle,       ViewsRectangle )
  EW_OBJECT  ( TimeList,        AnimatedListTimeList )
  EW_OBJECT  ( DayList,         AnimatedListDayList )
  EW_VARIABLE( Device,          AnimatedListDeviceClass )
  EW_VARIABLE( AutoState,       XInt32 )
  EW_OBJECT  ( AutoDemoTimer,   CoreTimer )
EW_END_OF_FIELDS( AnimatedListAnimatedList )

/* Virtual Method Table (VMT) for the class : 'AnimatedList::AnimatedList' */
EW_DEFINE_METHODS( AnimatedListAnimatedList, CoreGroup )
  EW_METHOD( initLayoutContext, void )( CoreRectView _this, XRect aBounds, CoreOutline 
    aOutline )
  EW_METHOD( GetRoot,           CoreRoot )( CoreView _this )
  EW_METHOD( Draw,              void )( CoreGroup _this, GraphicsCanvas aCanvas, 
    XRect aClip, XPoint aOffset, XInt32 aOpacity, XBool aBlend )
  EW_METHOD( HandleEvent,       XObject )( CoreView _this, CoreEvent aEvent )
  EW_METHOD( CursorHitTest,     CoreCursorHit )( CoreGroup _this, XRect aArea, XInt32 
    aFinger, XInt32 aStrikeCount, CoreView aDedicatedView, XSet aRetargetReason )
  EW_METHOD( ArrangeView,       XPoint )( CoreRectView _this, XRect aBounds, XEnum 
    aFormation )
  EW_METHOD( MoveView,          void )( CoreRectView _this, XPoint aOffset, XBool 
    aFastMove )
  EW_METHOD( GetExtent,         XRect )( CoreRectView _this )
  EW_METHOD( ChangeViewState,   void )( CoreGroup _this, XSet aSetState, XSet aClearState )
  EW_METHOD( OnSetBounds,       void )( CoreGroup _this, XRect value )
  EW_METHOD( OnSetFocus,        void )( CoreGroup _this, CoreView value )
  EW_METHOD( DispatchEvent,     XObject )( CoreGroup _this, CoreEvent aEvent )
  EW_METHOD( BroadcastEvent,    XObject )( CoreGroup _this, CoreEvent aEvent, XSet 
    aFilter )
  EW_METHOD( UpdateLayout,      void )( CoreGroup _this, XPoint aSize )
  EW_METHOD( UpdateViewState,   void )( CoreGroup _this, XSet aState )
  EW_METHOD( InvalidateArea,    void )( CoreGroup _this, XRect aArea )
  EW_METHOD( FindSiblingView,   CoreView )( CoreGroup _this, CoreView aView, XSet 
    aFilter )
  EW_METHOD( Restack,           void )( CoreGroup _this, CoreView aView, XInt32 
    aOrder )
  EW_METHOD( Remove,            void )( CoreGroup _this, CoreView aView )
  EW_METHOD( Add,               void )( CoreGroup _this, CoreView aView, XInt32 
    aOrder )
EW_END_OF_METHODS( AnimatedListAnimatedList )

/* Slot method to trigger the next phase of the auto demo. */
void AnimatedListAnimatedList_AutoDemoSlot( AnimatedListAnimatedList _this, XObject 
  sender );

#ifdef __cplusplus
  }
#endif

#endif /* _AnimatedListAnimatedList_H */

/* Embedded Wizard */
