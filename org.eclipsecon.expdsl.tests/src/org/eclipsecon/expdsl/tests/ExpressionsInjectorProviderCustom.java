package org.eclipsecon.expdsl.tests;

import org.eclipsecon.expdsl.ExpressionsInjectorProvider;
import org.eclipsecon.expdsl.ExpressionsRuntimeModule;
import org.eclipsecon.expdsl.ExpressionsStandaloneSetup;

import com.google.inject.Guice;
import com.google.inject.Injector;

public class ExpressionsInjectorProviderCustom extends ExpressionsInjectorProvider {

	@Override
	protected Injector internalCreateInjector() {
		return new ExpressionsStandaloneSetup() {
			@Override
			public Injector createInjector() {
				return Guice.createInjector(new ExpressionsRuntimeModule() {
					// this is required only by the CompilationTestHelper since
					// Xtext 2.7
					@SuppressWarnings({ "unused" })
					public Class<? extends org.eclipse.xtend.lib.macro.file.MutableFileSystemSupport> bindMutableFileSystemSupport() {
						return org.eclipse.xtext.xbase.file.JavaIOFileSystemSupport.class;
					}

					// this is required only by the CompilationTestHelper since
					// Xtext 2.7
					@SuppressWarnings({ "unused" })
					public Class<? extends com.google.inject.Provider<org.eclipse.xtext.xbase.file.WorkspaceConfig>> provideWorkspaceConfig() {
						return org.eclipse.xtext.xbase.file.RuntimeWorkspaceConfigProvider.class;
					}
				});
			}
		}.createInjectorAndDoEMFRegistration();
	}
}
